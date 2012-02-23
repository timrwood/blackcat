//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


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
        
        // jump controller
        _jumpController = [[BCHeroJumpController alloc] initWithHero:self];
        
        // create ragdoll
        _resetWhenDestroyed = YES;
        
        // debug emitter
        //[self createEmitter];
        
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
    [_jumpController updateBeforePhysics];
    [self updateVelocity];
}

- (void)updateBeforeAnimation {
    [_type updateBeforeAnimation];
    [_jumpController updateBeforeAnimation];
}

- (void)updateBeforeRender {
    [_type updateBeforeRender];
    [_jumpController updateBeforeRender];
    //[self updateCrash];
    [self updateCamera];
    [self updateSkeleton];
    [self updateEmitter];
}

- (void)updateCamera {
    [[BCGlobalManager manager] setIdealCameraPositionX:[_type modifyCameraPosition:[_body position]].x];
    
    // update hero position
    [[BCGlobalManager manager] setHeroPosition:[_body position]];
}

- (void)updateVelocity {
    GLKVector2 velocity = [_body linearVelocity];
    velocity = [_jumpController modifyVelocity:velocity];
    velocity = [_type modifyVelocity:velocity];
    [_body setLinearVelocity:velocity];
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
#pragma mark touch


- (void)touchBeganAtPoint:(GLKVector2)point {
    if (point.y < [[AHScreenManager manager] screenHeight] * 0.25f) {
        [[AHSceneManager manager] goToScene:[[BCClassSelectionScene alloc] init]];
    } else {
        [_jumpController jump];
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
    _jumpController = nil;
    
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
    
    GLKVector2 velocity = [_body linearVelocity];
    velocity = [_jumpController modifyVelocity:velocity];
    velocity = [_type modifyVelocity:velocity];
    
    BCHeroActorRagdoll *ragdoll = [[BCHeroActorRagdoll alloc] initFromSkeleton:[_skeleton skeleton]];
    [ragdoll setLinearVelocity:velocity];
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
