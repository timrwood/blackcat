//
//  AHPhysicsSkeleton.h
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSkeletonStruct.h"
#import "AHActorComponent.h"


@class AHPhysicsRevoluteJoint;
@class AHPhysicsLimb;
@class AHPhysicsRect;


@interface AHPhysicsSkeleton : AHActorComponent {
@private;
    AHPhysicsLimb *_armA;
    AHPhysicsLimb *_armB;
    AHPhysicsLimb *_legA;
    AHPhysicsLimb *_legB;
    
    AHPhysicsRect *_torso;
    AHPhysicsRect *_head;
    AHPhysicsRevoluteJoint *_neck;
    
    GLKVector2 _position;
    AHSkeleton _skeleton;
    
    AHSkeletonConfig _config;
}


#pragma mark -
#pragma mark init


- (id)initFromSkeleton:(AHSkeleton)skeleton
     andSkeletonConfig:(AHSkeletonConfig)config;


#pragma mark -
#pragma mark limits


- (void)setUpperLimits:(AHSkeleton)upper 
        andLowerLimits:(AHSkeleton)lower;


#pragma mark -
#pragma mark sizes


- (AHSkeleton)skeleton;
- (void)setFromSkeletonConfig:(AHSkeletonConfig)config;
- (AHSkeletonConfig)skeletonConfig;
- (void)setLegWidth:(float)width;
- (void)setLegLength:(float)length;
- (void)setArmWidth:(float)width;
- (void)setArmLength:(float)length;
- (void)setPosition:(GLKVector2)position;


#pragma mark -
#pragma mark velocity


- (void)setLinearVelocity:(GLKVector2)velocity;


@end
