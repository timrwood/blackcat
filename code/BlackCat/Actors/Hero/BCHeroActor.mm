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
#import "AHActorMessage.h"
#import "AHPhysicsCircle.h"
#import "AHGraphicsLimb.h"

#import "BCHeroActor.h"
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
        
        _limb = [[AHGraphicsLimb alloc] init];
        [_limb setLength:5.0f];
        [_limb setWidth:0.5f];
        [_limb setTextureRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_limb setTextureKey:@"debug-grid.png"];
        [self addComponent:_limb];
        [[AHGraphicsManager manager] addObject:_limb toLayerIndex:GFX_LAYER_BACKGROUND];
        
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
    //[self updateVelocity];
    [self updateCamera];
    //[self updateJumpability];
    _limbAngle += 0.02f;
    [_limb setAngle:_limbAngle];
    [[AHGraphicsManager camera] setWorldPosition:GLKVector2Make(0.0f, 3.0f)];
    
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
    if (_dashSpeed == 0.0f) {
        _dashSpeed = 30.0f;
    }
}

#pragma mark -
#pragma mark destruction


- (void)cleanupBeforeDestruction {
    [[AHSceneManager manager] reset];
    [super cleanupBeforeDestruction];
}


@end
