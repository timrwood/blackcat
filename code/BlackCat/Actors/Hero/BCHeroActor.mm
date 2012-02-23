//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define CAMERA_JUMP_DISTANCE 4.0f

#define HERO_WIDTH 0.3f
#define HERO_HEIGHT 1.0f
#define HERO_HEIGHT_RAYCAST_RADIUS_RATIO 1.1f
#define HERO_WIDTH_RAYCAST_RADIUS_RATIO 1.5f

#define MAX_SAFETY_RANGE_FRAMES 3

#define JUMP_INITIAL_VELOCITY 70.0f

#define JUMP_UPWARD_SLOWING 1.35f
#define JUMP_DOWNWARD_SLOWING 1.4f
#define JUMP_MAX_DOWNWARD_SLOWING 10.0f

#define DASH_SLOW_SPEED 1.0f

#define INITIAL_RUN_SPEED 20.0f

#define STATE_CAN_JUMP 0
#define STATE_IS_JUMPING 1
#define STATE_CANNOT_JUMP 2


#import "AHTimeManager.h"
#import "AHGraphicsManager.h"
#import "AHInputManager.h"
#import "AHSceneManager.h"

#import "AHParticlePointRenderer.h"

#import "AHMathUtils.h"

#import "AHScreenManager.h"
#import "AHActorManager.h"
#import "AHActorMessage.h"
#import "AHPhysicsPill.h"

#import "BCHeroActor.h"
#import "BCHeroActorRagdoll.h"
#import "BCGlobalTypes.h"
#import "BCGlobalManager.h"
#import "BCClassSelectionScene.h"

#import "BCHeroTypeBoxer.h"
#import "BCHeroTypeDetective.h"
#import "BCHeroTypeFemme.h"


@implementation BCHeroActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
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
        
        _body = [[AHPhysicsPill alloc] initFromSize:CGSizeMake(HERO_WIDTH, HERO_HEIGHT)];
        [_body setRestitution:0.0f];
        [_body setStatic:NO];
        [_body setCategory:PHY_CAT_HERO];
        [_body ignoreCategory:PHY_CAT_DEBRIS];
        [_body setRestitution:0.0f];
        [_body setDelegate:self];
        [_body setFixedRotation:YES];
        [_body setFriction:0.0f];
        [_body setBullet:YES];
        [self addComponent:_body];
        
        // jumping state
        _jumpingState = [[AHLogicState alloc] init];
        [_jumpingState setDelegate:self];
        [self addComponent:_jumpingState];
        
        // input
        CGRect rectLeft = [[AHScreenManager manager] screenRect];
        rectLeft.size.width = [[AHScreenManager manager] screenWidth] * 0.25;
        CGRect rectRight = [[AHScreenManager manager] screenRect];
        rectRight.size.width = [[AHScreenManager manager] screenWidth] - rectLeft.size.width;
        rectRight.origin.x = rectLeft.size.width;
        AHInputComponent *_inputLeft = [[AHInputComponent alloc] initWithScreenRect:rectLeft];
        AHInputComponent *_inputRight = [[AHInputComponent alloc] initWithScreenRect:rectRight];
        [_inputLeft setDelegate:self];
        [_inputRight setDelegate:_type];
        [self addComponent:_inputLeft];
        [self addComponent:_inputRight];
        
        // graphics
        _skeleton = [[AHGraphicsSkeleton alloc] init];
        [_skeleton setSkeleton:AHSkeletonZero()];
        [_skeleton setDepth:Z_PHYSICS_DEPTH];
        [_skeleton setLayerIndex:GFX_LAYER_BACKGROUND];
        [self addComponent:_skeleton];
        
        // setup the type
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
        
        [self createEmitter];
        
        //[[AHTimeManager manager] setWorldToRealRatio:5.0f];
    }
    return self;
}


#pragma mark -
#pragma mark emitter


- (void)createEmitter {
    _emitter = [[AHParticleEmitter alloc] init];
    AHParticleEmitterConfig config;
    config.position = GLKVector3Make(0.0f, 0.0f, Z_BUILDING_FRONT);
    config.positionVariance = GLKVector3Make(0.0f, -1.0f, 0.0f);
    config.linearVelocity = GLKVector3Make(0.0f, -5.0f, 0.0f);
    config.linearVelocityVariance = GLKVector3Make(1.0f, 2.0f, 10.0f);
    config.lifetime = 0.4f;
    config.lifetimeVariance = 0.1f;
    config.gravity = GLKVector3Make(0.0f, 5.0f, 0.0f);
    config.particlesPerSecond = 200.0f;
    config.hasLifetime = NO;
    [_emitter setConfig:config];
    [self addComponent:_emitter];
    
    AHParticlePointRenderer *r = [[AHParticlePointRenderer alloc] init];
    [_emitter setRenderer:r];
}


#pragma mark -
#pragma mark body


- (AHPhysicsBody *)body {
    return _body;
}


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    [_type updateBeforePhysics];
    [self updateVelocity];
}

- (void)updateBeforeAnimation {
    [_type updateBeforeAnimation];
}

- (void)updateBeforeRender {
    [_type updateBeforeRender];
    [self updateJumpability];
    [self updateCrash];
    [self updateCamera];
    [self updateSkeleton];
    [self updateEmitter];
}

- (void)updateVelocity {
    AHParticleEmitterConfig config = [_emitter config];
    config.linearVelocity.x = [_body linearVelocity].x - 3.0f;
    [_emitter setConfig:config];
    
    GLKVector2 velocity = [_body linearVelocity];
    
    // increase velocity
    if (_runSpeed < 15.0f) {
        //_runSpeed += _speedIncrease;
    } else if (_runSpeed < 50.0f) {
        //_runSpeed += _speedIncrease / 2.0f;
    }
    velocity.x = _runSpeed;
    
    // make jumping snappier
    if (velocity.y > 0.0f && velocity.y < JUMP_MAX_DOWNWARD_SLOWING) {
        velocity.y *= _downwardSlowing;
    } else if (velocity.y < 0.0f) {
        velocity.y /= _upwardSlowing;
    }
    
    // set vars
    [_body setLinearVelocity:[_type modifyVelocity:velocity]];
}

- (void)updateJumpability {
    GLKVector2 foot = [_body position];
    foot.y += HERO_HEIGHT * HERO_HEIGHT_RAYCAST_RADIUS_RATIO;
    
    int cat = [[AHPhysicsManager cppManager] getFirstActorCategoryWithTag:PHY_TAG_JUMPABLE from:[_body position] to:foot];
    
    if (cat != PHY_CAT_NONE) {
        [_jumpingState changeState:STATE_CAN_JUMP];
        _safetyRange = MAX_SAFETY_RANGE_FRAMES;
    } else {
        if (_safetyRange > 0) {
            _safetyRange--;
        } else {
            [_jumpingState changeState:STATE_CANNOT_JUMP];
        }
    }
}

- (void)updateCamera {
    [[BCGlobalManager manager] setIdealCameraPositionX:[_type modifyCameraPosition:[_body position]].x];
    
    // update hero position
    [[BCGlobalManager manager] setHeroPosition:[_body position]];
}

- (void)updateSkeleton {
    [_skeleton setPosition:[_body position]];
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

- (void)updateEmitter {
    AHParticleEmitterConfig config = [_emitter config];
    GLKVector3 pos = GLKVector3Make([_body position].x, [_body position].y, Z_PHYSICS_DEPTH);
    config.position = pos;
    [_emitter setConfig:config];
}


#pragma mark -
#pragma mark state


- (void)stateChangedTo:(int)newState {
    if (newState == STATE_IS_JUMPING ){
        float velx = [_body linearVelocity].x;
        [_body setLinearVelocity:GLKVector2Make(velx, -JUMP_INITIAL_VELOCITY)];
        // we need to send a message so that the recorder can estimate paths better 
        [self sendMessage:[[AHActorMessage alloc] initWithType:(int)MSG_HERO_JUMP]];
    }
    if (newState == STATE_CAN_JUMP) {
        [self sendMessage:[[AHActorMessage alloc] initWithType:(int)MSG_HERO_LAND]];
    }
}


#pragma mark -
#pragma mark touch


- (void)touchBeganAtPoint:(GLKVector2)point {
    if (point.y < [[AHScreenManager manager] screenHeight] * 0.25f) {
        [[AHSceneManager manager] goToScene:[[BCClassSelectionScene alloc] init]];
    } else {
        [self inputJump];
    }
}

- (void)inputJump {
    if ([_jumpingState isState:STATE_CAN_JUMP]) {
        [_jumpingState changeState:STATE_IS_JUMPING];
    }
}


#pragma mark -
#pragma mark destruction


- (void)cleanupBeforeDestruction {
    if (_resetWhenDestroyed) {
        [[AHSceneManager manager] reset];
    }
    
    // cleanup type
    [_type cleanupAfterRemoval];
    _type = nil;
    _body = nil;
    _skeleton = nil;
    _jumpingState = nil;
    
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
    if (![_type willCollideWithAnyObstacle]) {
        return NO;
    }
    
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
