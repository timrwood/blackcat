//
//  BCHeroType.h
//  BlackCat
//
//  Created by Tim Wood on 2/1/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsSkeleton.h"
#import "AHActorComponent.h"
#import "AHInputComponent.h"


@class BCHeroActor;
@class AHPhysicsBody;
@class AHPhysicsSkeleton;


@interface BCHeroType : AHActorComponent <AHInputDelegate> {
    
}


#pragma mark -
#pragma mark hero


@property (nonatomic, weak) BCHeroActor *hero;
- (GLKVector2)heroPosition;


#pragma mark -
#pragma mark skin


- (void)configSkeletonSkin:(AHGraphicsSkeleton *)skeleton;
- (void)configSkeletonBody:(AHPhysicsSkeleton *)skeleton;
- (AHSkeletonConfig)graphicsConfig;
- (AHSkeletonConfig)physicsConfig;
- (AHSkeleton)upperLimit;
- (AHSkeleton)lowerLimit;


#pragma mark -
#pragma mark velocity


- (GLKVector2)modifyVelocity:(GLKVector2)velocity;
- (GLKVector2)velocityToPoint:(GLKVector2)point
                      withMax:(float)velocity;


#pragma mark -
#pragma mark collision


- (BOOL)willCollideWithAnyObstacle;
- (BOOL)willCollideWithObstacle:(AHPhysicsBody *)obstacle;


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics;
- (void)updateBeforeAnimation;
- (void)updateBeforeRender;


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval;


@end
