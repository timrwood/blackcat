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


@class AHPhysicsPill;
@class AHAnimationSkeletonTrack;
@class AHGraphicsLimb;
@class AHGraphicsSkeleton;
@class BCHeroType;


@interface BCHeroActor : AHActor <AHInputDelegate, AHContactDelegate> {
@private;
    AHPhysicsPill *_body;
    AHInputComponent *_input;
    
    BCHeroType *_type;
    
    AHGraphicsSkeleton *_skeleton;
    AHGraphicsLimb *_limb;
    float _limbAngle;
    
    BOOL _canJump;
    BOOL _isJumping;
    
    float _runSpeed;
    int _safetyRange;
    
    float _upwardSlowing;
    float _downwardSlowing;
    
    float _speedIncrease;
    
    float _dashSpeed;
    
    float _halfScreenWidth;
    
    AHAnimationSkeletonTrack *_track;
    
    BOOL _resetWhenDestroyed;
    
    BOOL _madeRagdoll;
}


#pragma mark -
#pragma mark update


- (void)updateVelocity;
- (void)updateJumpability;
- (void)updateCamera;
- (void)updateSkeleton;
- (void)updateCrash;


#pragma mark -
#pragma mark input


- (void)inputJump;
- (void)inputDash;


#pragma mark -
#pragma mark ragdoll


- (void)makeRagdoll;


@end
