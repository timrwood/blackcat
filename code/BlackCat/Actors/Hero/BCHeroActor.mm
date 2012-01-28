//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define CAMERA_JUMP_DISTANCE 4.0f
#define RADIUS 0.5f
#define RAYCAST_RADIUS_RATIO 1.4f
#define MAX_SAFETY_RANGE_FRAMES 3

#define BASE_UPWARD_SLOWING 1.2f
#define BASE_DOWNWARD_SLOWING 1.1f

#define DASH_SLOW_SPEED 1.0f


#import "AHTimeManager.h"
#import "AHGraphicsManager.h"
#import "AHInputManager.h"
#import "AHSceneManager.h"

#import "AHMathUtils.h"

#import "AHAnimationSkeletonCache.h"
#import "AHAnimationSkeletonTrack.h"
#import "AHActorManager.h"
#import "AHActorMessage.h"
#import "AHPhysicsCircle.h"
#import "AHGraphicsRect.h"
#import "AHGraphicsLimb.h"
#import "AHGraphicsSkeleton.h"

#import "BCHeroActor.h"
#import "BCHeroActorRagdoll.h"
#import "BCGlobalTypes.h"
#import "BCGlobalManager.h"


@implementation BCHeroActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsCircle alloc] initFromRadius:RADIUS andPosition:GLKVector2Make(0.0f, 0.0f)];
        [_body setRestitution:0.1f];
        [_body setStatic:NO];
        [_body setCategory:PHY_CAT_HERO];
        [self addComponent:_body];
        
        CGRect inputRect = [[UIScreen mainScreen] bounds];
        float w = inputRect.size.width;
        inputRect.size.width = inputRect.size.height;
        inputRect.size.height = w;
        _halfScreenWidth = inputRect.size.width / 2.0f;
        _input = [[AHInputComponent alloc] initWithScreenRect:inputRect];
        [_input setDelegate:self];
        [self addComponent:_input];
        
        AHSkeleton skeleton;
        _skeleton = [[AHGraphicsSkeleton alloc] init];
        config.armWidth = 0.1f;
        config.armLength = 1.0f;
        config.legWidth = 0.1f;
        config.legLength = 1.0f;
        config.torsoWidth = 0.2f;
        config.torsoHeight = 0.6f;
        config.headTop = 0.2f;
        config.headBottom = 0.1f;
        config.headLeft = 0.1f;
        config.headRight = 0.1f;
        [_skeleton setSkeleton:skeleton];
        [_skeleton setFromSkeletonConfig:config];
        [_skeleton setTextureKey:@"debug-grid.png"];
        [_skeleton setArmsTextureRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skeleton setLegsTextureRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [[_skeleton torso] setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [[_skeleton head] setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        
        _resetWhenDestroyed = YES;
        
        [self addComponent:_skeleton];
        [[AHGraphicsManager manager] addObject:_skeleton toLayerIndex:GFX_LAYER_BACKGROUND];
        
        _runSpeed = 8.0f;
        
        _upwardSlowing = powf(BASE_UPWARD_SLOWING, 60.0f / [[AHTimeManager manager] realFramesPerSecond]);
        _downwardSlowing = powf(BASE_DOWNWARD_SLOWING, 60.0f / [[AHTimeManager manager] realFramesPerSecond]);
        
        _speedIncrease = 0.01f * 60.0f / [[AHTimeManager manager] realFramesPerSecond];
        
        _track = [[AHAnimationSkeletonCache manager] animationForKey:@"demo"];
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    [self updateVelocity];
    [self updateCamera];
    [self updateJumpability];
    
    
    _limbAngle += 0.02f;
    //[_limb setAngle:_limbAngle];
    AHSkeleton skeleton;
    //skeleton.x = 2.0f;
    //skeleton.y = 1.0f;
    
    skeleton.hipA = _limbAngle;
    skeleton.hipB = _limbAngle / 2.0f;
    skeleton.elbowA = _limbAngle;
    skeleton.elbowB = -_limbAngle / 2.0f;
    skeleton.kneeA = -_limbAngle;
    skeleton.kneeB = _limbAngle / 2.0f;
    skeleton.shoulderA = -_limbAngle;
    skeleton.shoulderB = _limbAngle / 2.0f;
    skeleton.neck = _limbAngle;
    skeleton.waist = -_limbAngle / 2.0f;
    
    /*
    skeleton.hipA = M_TAU_8;
    skeleton.hipB = -M_TAU_4;
    skeleton.kneeA = M_TAU_8;
    skeleton.kneeB = M_TAU_4 + M_TAU_8;
    skeleton.elbowA = -M_TAU_4;
    skeleton.elbowB = -M_TAU_4;
    skeleton.shoulderA = -M_TAU_4;
    skeleton.shoulderB = M_TAU_8;
    skeleton.neck = M_TAU_8;
    skeleton.waist = M_TAU_8 / 2.0f;
     */
    
    //AHSkeleton skeleton;
    skeleton.x = [_body position].x;
    skeleton.y = [_body position].y;
    /*skeleton.hipA = 0.0f;
    skeleton.hipB = 0.0f;
    skeleton.kneeA = 0.0f;
    skeleton.kneeB = 0.0f;
    skeleton.elbowA = 0.0f;
    skeleton.elbowB = 0.0f;
    skeleton.shoulderA = 0.0f;
    skeleton.shoulderB = 0.0f;
    skeleton.neck = 0.0f;
    skeleton.waist = 0.0f;*/
    [_skeleton setSkeleton:skeleton];
    
    //[[AHGraphicsManager camera] setWorldPosition:GLKVector2Make(2.0f, 0.0f)];
    //[[AHGraphicsManager camera] setWorldZoom:3.0f];
    
    // debug
    //float time = fmodf([_body position].x, 2.5f) / 2.5f;
    //AHSkeleton skeleton = [_track valueAtTime:time];
    //dlog(@"skeleton %F %F", skeleton.x, skeleton.y);
}

- (void)updateVelocity {
    // increase velocity
    float vely = [_body linearVelocity].y;
    if (_runSpeed < 15.0f) {
        _runSpeed += _speedIncrease;
    } else if (_runSpeed < 50.0f) {
        _runSpeed += _speedIncrease / 2.0f;
    }
    
    // make jumping snappier
    if (vely > 0.0f) {
        if (vely < 10.0f) {
            vely *= _downwardSlowing; // travelling downward
        }
    } else {
        vely /= _upwardSlowing; // travelling upward
    }
    
    // slow down dash
    _dashSpeed = fmaxf(0.0f, _dashSpeed - DASH_SLOW_SPEED);
    
    // set vars
    [_body setLinearVelocity:GLKVector2Make(_runSpeed + _dashSpeed, vely)];
    [[BCGlobalManager manager] setHeroSpeed:_runSpeed];
}

- (void)updateJumpability {
    GLKVector2 foot = [_body position];
    foot.y += RADIUS * RAYCAST_RADIUS_RATIO;
    
    int cat = [[AHPhysicsManager cppManager] getFirstActorCategoryWithTag:PHY_TAG_JUMPABLE 
                                                                     from:[_body position] 
                                                                       to:foot];
    
    if (cat != PHY_CAT_NONE) {
        _canJump = YES;
        _safetyRange = MAX_SAFETY_RANGE_FRAMES;
    } else {
        if (_safetyRange > 0) {
            _safetyRange--;
        } else {
            _canJump = NO;
        }
    }
    
    // send landing message
    if (_isJumping && _canJump) {
        _isJumping = NO;
        [self sendMessage:[[AHActorMessage alloc] initWithType:(int)MSG_HERO_LAND]];
    }
}

- (void)updateCamera {
    float buildingHeight = [[BCGlobalManager manager] buildingHeight];
    float jumpPercent = fmaxf(buildingHeight - CAMERA_JUMP_DISTANCE, fminf([_body position].y, buildingHeight));
    jumpPercent = (jumpPercent - buildingHeight) / CAMERA_JUMP_DISTANCE;
    
    GLKVector2 cameraPos = [_body position];
    cameraPos.x += 4.0f;
    cameraPos.y = [[BCGlobalManager manager] buildingHeight] - 3.0f - (jumpPercent * 2.0f);
    
    [[AHGraphicsManager camera] setWorldPosition:cameraPos];
    //[[AHGraphicsManager camera] setWorldZoom:100.0f];
    
    [[BCGlobalManager manager] setHeroPosition:[_body position]];
}


#pragma mark -
#pragma mark touch


- (void)touchBeganAtPoint:(GLKVector2)point {
    if (point.x > _halfScreenWidth) {
        [self inputDash];
    } else {
        [self inputJump];
    }
}

- (void)inputJump {
    if (_canJump) {
        float velx = [_body linearVelocity].x;
        [_body setLinearVelocity:GLKVector2Make(velx, -30.0f)];
        _canJump = NO;
        _isJumping = YES;
        [self sendMessage:[[AHActorMessage alloc] initWithType:(int)MSG_HERO_JUMP]];
    }
}

- (void)inputDash {
    [self safeDestroy];
    
    _resetWhenDestroyed = NO;
    
    BCHeroActorRagdoll *ragdoll = [[BCHeroActorRagdoll alloc] initFromSkeleton:[_skeleton skeleton] andSkeletonConfig:config];
    //[ragdoll setLinearVelocity:[_body linearVelocity]];
    [[AHActorManager manager] add:ragdoll];
    
    AHSkeleton upper;
    upper.hipA = M_TAU_16;
    upper.hipB = M_TAU_16;
    upper.kneeA = M_TAU_4 + M_TAU_8;
    upper.kneeB = M_TAU_4 + M_TAU_8;
    upper.elbowA = 0.0f;
    upper.elbowB = 0.0f;
    upper.shoulderA = M_TAU_4;
    upper.shoulderB = M_TAU_4;
    upper.neck = M_TAU_8;
    
    AHSkeleton lower;
    lower.hipA = -(M_TAU_4 + M_TAU_8);
    lower.hipB = -(M_TAU_4 + M_TAU_8);
    lower.kneeA = 0.0f;
    lower.kneeB = 0.0f;
    lower.elbowA = -(M_TAU_4 + M_TAU_8);
    lower.elbowB = -(M_TAU_4 + M_TAU_8);
    lower.shoulderA = -M_TAU_2;
    lower.shoulderB = -M_TAU_2;
    lower.neck = -M_TAU_8;
    
    [ragdoll setUpperLimits:upper andLowerLimits:lower];
    
    if (_dashSpeed == 0.0f) {
        _dashSpeed = 30.0f;
    }
}

#pragma mark -
#pragma mark destruction


- (void)cleanupBeforeDestruction {
    if (_resetWhenDestroyed) {
        [[AHSceneManager manager] reset];
    }
    [super cleanupBeforeDestruction];
}


@end
