//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define CAMERA_JUMP_DISTANCE 4.0f

#define HERO_WIDTH 0.2f
#define HERO_HEIGHT 0.8f
#define HERO_HEIGHT_RAYCAST_RADIUS_RATIO 1.1f
#define HERO_WIDTH_RAYCAST_RADIUS_RATIO 1.5f

#define MAX_SAFETY_RANGE_FRAMES 3

#define JUMP_INITIAL_VELOCITY 30.0f

#define JUMP_UPWARD_SLOWING 1.35f
#define JUMP_DOWNWARD_SLOWING 1.4f

#define DASH_SLOW_SPEED 1.0f

#define INITIAL_RUN_SPEED 8.0f


#import "AHTimeManager.h"
#import "AHGraphicsManager.h"
#import "AHInputManager.h"
#import "AHSceneManager.h"

#import "AHMathUtils.h"

#import "AHScreenManager.h"
#import "AHAnimationSkeletonCache.h"
#import "AHAnimationSkeletonTrack.h"
#import "AHActorManager.h"
#import "AHActorMessage.h"
#import "AHPhysicsPill.h"
#import "AHGraphicsRect.h"
#import "AHGraphicsLimb.h"
#import "AHGraphicsSkeleton.h"

#import "BCHeroActor.h"
#import "BCHeroActorRagdoll.h"
#import "BCGlobalTypes.h"
#import "BCGlobalManager.h"

#import "BCHeroTypeBoxer.h"
#import "BCHeroTypeDetective.h"
#import "BCHeroTypeFemme.h"


@implementation BCHeroActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsPill alloc] initFromSize:CGSizeMake(HERO_WIDTH, HERO_HEIGHT)];
        [_body setRestitution:0.0f];
        [_body setStatic:NO];
        [_body setCategory:PHY_CAT_HERO];
        [_body setRestitution:0.0f];
        [_body setDelegate:self];
        [_body setFixedRotation:YES];
        [_body setFriction:0.0f];
        [self addComponent:_body];
        
        // input
        _input = [[AHInputComponent alloc] initWithScreenRect:[[AHScreenManager manager] screenRect]];
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
                _type = [[BCHeroTypeBoxer alloc] init];
                break;
            case HERO_TYPE_DETECTIVE:
                _type = [[BCHeroTypeDetective alloc] init];
                break;
            case HERO_TYPE_FEMME:
                _type = [[BCHeroTypeFemme alloc] init];
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
    foot.y += HERO_HEIGHT * HERO_HEIGHT_RAYCAST_RADIUS_RATIO;
    
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
    //cameraPos.y = [[BCGlobalManager manager] buildingHeight] - 1.0f;
    cameraPos.y = [_body position].y;
    
    [[AHGraphicsManager camera] setWorldPosition:cameraPos];
    [[AHGraphicsManager camera] setWorldZoom:3.0f];
    
    [[BCGlobalManager manager] setHeroPosition:[_body position]];
}

- (void)updateSkeleton {
    //_limbAngle += 0.02f;
    AHSkeleton skeleton;
    skeleton.x = [_body position].x;
    skeleton.y = [_body position].y;
    /*skeleton.hipA = _limbAngle;
    skeleton.hipB = _limbAngle / 2.0f;
    skeleton.elbowA = _limbAngle;
    skeleton.elbowB = -_limbAngle / 2.0f;
    skeleton.kneeA = -_limbAngle;
    skeleton.kneeB = _limbAngle / 2.0f;
    skeleton.shoulderA = -_limbAngle;
    skeleton.shoulderB = _limbAngle / 2.0f;
    skeleton.neck = _limbAngle;
    skeleton.waist = -_limbAngle / 2.0f;*/
    [_skeleton setSkeleton:skeleton];
}

- (void)updateCrash {
    GLKVector2 startPos = [_body position];
    startPos.y += HERO_HEIGHT - HERO_WIDTH;
    GLKVector2 endPos = startPos;
    endPos.x += HERO_WIDTH * HERO_WIDTH_RAYCAST_RADIUS_RATIO;
    
    int cat = [[AHPhysicsManager cppManager] getFirstActorCategoryWithTag:PHY_TAG_CRASHABLE from:startPos to:endPos];
    
    if (cat != PHY_CAT_NONE && [_type willCollideWithAnyObstacle]) {
        [self makeRagdoll];
    }
}


#pragma mark -
#pragma mark touch


- (void)touchBeganAtPoint:(GLKVector2)point {
    if (point.x > [[AHScreenManager manager] screenWidth] / 2.0f) {
        [_type tappedSecondaryAtPoint:point];
    } else {
        [self inputJump];
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
    
    // dont make more than one ragdoll
    if (_madeRagdoll) {
        return;
    }
    _madeRagdoll = YES;
    
    _resetWhenDestroyed = NO;
    
    BCHeroActorRagdoll *ragdoll = [[BCHeroActorRagdoll alloc] initFromSkeleton:[_skeleton skeleton]];
    [ragdoll setLinearVelocity:GLKVector2Make(_runSpeed, [_body linearVelocity].y)];
    [[AHActorManager manager] add:ragdoll];
}


#pragma mark -
#pragma mark contacts


- (BOOL)willCollideWith:(AHPhysicsBody *)contact {
    if ([contact hasTag:PHY_TAG_BREAKABLE] || [contact hasTag:PHY_TAG_PHASEWALKABLE]) {
        // is crashable
        return [_type willCollideWithObstacle:contact];
    }
    if ([contact hasTag:PHY_TAG_ONE_WAY_FLOOR]) {
        if ([contact position].y < [_body position].y + HERO_HEIGHT) {
            return NO;
        }
    }
    return YES;
}


@end
