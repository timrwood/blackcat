//
//  BCHeroActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHSkeletonStruct.h"
#import "AHActor.h"
#import "AHInputComponent.h"
#import "AHContactDelegate.h"
#import "AHLogicState.h"
#import "AHGraphicsSkeleton.h"
#import "AHParticleEmitter.h"
#import "BCHeroJumpController.h"


@class AHPhysicsPill;
@class BCHeroType;


@interface BCHeroActor : AHActor <AHInputDelegate, AHContactDelegate, AHLogicDelegate> {
@private;
    AHPhysicsPill *_body;
    BCHeroType *_type;
    AHGraphicsSkeleton *_skeleton;
    AHParticleEmitter *_emitter;
    BCHeroJumpController *_jumpController;
    
    BOOL _resetWhenDestroyed;
    BOOL _madeRagdoll;
}


#pragma mark -
#pragma mark emitter


- (void)createEmitter;


#pragma mark -
#pragma mark body


- (AHPhysicsBody *)body;


#pragma mark -
#pragma mark update


- (void)updateVelocity;
- (void)updateCamera;
- (void)updateSkeleton;
- (void)updateCrash;
- (void)updateEmitter;


#pragma mark -
#pragma mark ragdoll


- (void)makeRagdoll;


@end
