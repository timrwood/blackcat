//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define CAMERA_JUMP_DISTANCE 4.0f

#define RADIUS 0.5f
#define RAYCAST_RADIUS_RATIO 1.4f

#define MAX_SAFETY_RANGE_FRAMES 3

#define JUMP_INITIAL_VELOCITY 25.0f

#define JUMP_UPWARD_SLOWING 1.4f
#define JUMP_DOWNWARD_SLOWING 1.2f

#define DASH_SLOW_SPEED 1.0f

#define INITIAL_RUN_SPEED 8.0f


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

#import "BCHeroTypeDetective.h"


@implementation BCHeroActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsCircle alloc] initFromRadius:RADIUS andPosition:GLKVector2Make(0.0f, 0.0f)];
        [_body setRestitution:0.0f];
        [_body setStatic:NO];
        [_body setCategory:PHY_CAT_HERO];
        [_body setRestitution:0.0f];
        [self addComponent:_body];
        
        // input
        CGRect inputRect = [[UIScreen mainScreen] bounds];
        float w = inputRect.size.width;
        inputRect.size.width = inputRect.size.height;
        inputRect.size.height = w;
        _halfScreenWidth = inputRect.size.width / 2.0f;
        _input = [[AHInputComponent alloc] initWithScreenRect:inputRect];
        [_input setDelegate:self];
        [self addComponent:_input];
        
        // graphics
        _skeleton = [[AHGraphicsSkeleton alloc] init];
        AHSkeleton skeleton;
        [_skeleton setSkeleton:skeleton];
        [_skeleton setLayerIndex:GFX_LAYER_BACKGROUND];
        [self addComponent:_skeleton];
        
        // init the type
        switch ([[BCGlobalManager manager] heroType]) {
            case HERO_TYPE_BOXER:
                _type = [[BCHeroTypeDetective alloc] init];
                break;
            case HERO_TYPE_DETECTIVE:
                _type = [[BCHeroTypeDetective alloc] init];
                break;
            case HERO_TYPE_FEMME:
                _type = [[BCHeroTypeDetective alloc] init];
                break;
            default:
                break;
        }
        [_type configSkeletonSkin:_skeleton];
        [_skeleton setFromSkeletonConfig:[_type graphicsConfig]];
        [_type setHero:self];
        
        _resetWhenDestroyed = YES;
        
        // vertical speeds
        _upwardSlowing = powf(JUMP_UPWARD_SLOWING, 60.0f / [[AHTimeManager manager] realFramesPerSecond]);
        _downwardSlowing = powf(JUMP_DOWNWARD_SLOWING, 60.0f / [[AHTimeManager manager] realFramesPerSecond]);
        
        // horizontal speeds
        _runSpeed = INITIAL_RUN_SPEED;
        _speedIncrease = 0.01f * [[AHTimeManager manager] realFramesPerSecond] / 60.0f;
        
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
    [self updateSkeleton];
    [self updateCrash];
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
    
    // we need to send a message so that the recorder can estimate paths better 
    if (_isJumping && _canJump) {
        _isJumping = NO;
        [self sendMessage:[[AHActorMessage alloc] initWithType:(int)MSG_HERO_LAND]];
    }
}

- (void)updateCamera {
    GLKVector2 cameraPos;
    cameraPos.x = [_body position].x + 2.0f;
    cameraPos.y = [[BCGlobalManager manager] buildingHeight] - 1.0f;
    
    [[AHGraphicsManager camera] setWorldPosition:cameraPos];
    [[AHGraphicsManager camera] setWorldZoom:3.0f];
    
    [[BCGlobalManager manager] setHeroPosition:[_body position]];
}

- (void)updateSkeleton {
    //_limbAngle += 0.02f;
    AHSkeleton skeleton;
    skeleton.x = [_body position].x;
    skeleton.y = [_body position].y;
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
    [_skeleton setSkeleton:skeleton];
}

- (void)updateCrash {
    GLKVector2 front = [_body position];
    front.x += RADIUS * 1.1f;
    
    int cat = [[AHPhysicsManager cppManager] getFirstActorCategoryWithTag:PHY_TAG_CRASHABLE 
                                                                     from:[_body position] 
                                                                       to:front];
    
    if (cat != PHY_CAT_NONE) {
        [self makeRagdoll];
    }
}


#pragma mark -
#pragma mark touch


- (void)touchBeganAtPoint:(GLKVector2)point {
    if (point.x > _halfScreenWidth) {
        [self inputDash];
    } else {
        [_type tappedSecondaryAtPoint:point];
    }
}

- (void)inputJump {
    if (_canJump) {
        float velx = [_body linearVelocity].x;
        [_body setLinearVelocity:GLKVector2Make(velx, -JUMP_INITIAL_VELOCITY)];
        _canJump = NO;
        _isJumping = YES;
        
        // we need to send a message so that the recorder can estimate paths better 
        [self sendMessage:[[AHActorMessage alloc] initWithType:(int)MSG_HERO_JUMP]];
    }
}

- (void)inputDash {
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
    
    // cleanup type
    [_type setHero:nil];
    _type = nil;
    
    [super cleanupBeforeDestruction];
}


#pragma mark -
#pragma mark ragdoll


- (void)makeRagdoll {
    [self safeDestroy];
    
    _resetWhenDestroyed = NO;
    
    BCHeroActorRagdoll *ragdoll = [[BCHeroActorRagdoll alloc] initFromSkeleton:[_skeleton skeleton]];
    [ragdoll setLinearVelocity:GLKVector2Make(_runSpeed, [_body linearVelocity].y)];
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
    upper.neck = M_TAU_16;
    
    AHSkeleton lower;
    lower.hipA = -(M_TAU_4 + M_TAU_8);
    lower.hipB = -(M_TAU_4 + M_TAU_8);
    lower.kneeA = 0.0f;
    lower.kneeB = 0.0f;
    lower.elbowA = -(M_TAU_4 + M_TAU_8);
    lower.elbowB = -(M_TAU_4 + M_TAU_8);
    lower.shoulderA = -M_TAU_2;
    lower.shoulderB = -M_TAU_2;
    lower.neck = -M_TAU_16;
    
    [ragdoll setUpperLimits:upper andLowerLimits:lower];
}


@end
