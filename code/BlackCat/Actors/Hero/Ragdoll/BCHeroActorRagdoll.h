//
//  BCHeroActorRagdoll.h
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActor.h"
#import "AHInputComponent.h"


@class AHPhysicsSkeleton;
@class AHGraphicsSkeleton;


@interface BCHeroActorRagdoll : AHActor <AHInputDelegate> {
@private;
    AHInputComponent *_input;
    AHPhysicsSkeleton *_ragdoll;
    AHGraphicsSkeleton *_skin;
    
    float _timeRatio;
    
    float _creationTime;
}


#pragma mark -
#pragma mark init


- (id)initFromSkeleton:(AHSkeleton)skeleton;


#pragma mark -
#pragma mark limits


- (void)setUpperLimits:(AHSkeleton)upper 
        andLowerLimits:(AHSkeleton)lower;


#pragma mark -
#pragma mark velocity


- (void)setLinearVelocity:(GLKVector2)velocity;


@end
