//
//  BCHeroType.h
//  BlackCat
//
//  Created by Tim Wood on 2/1/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsSkeleton.h"
#import "AHActorComponent.h"


@class BCHeroActor;
@class AHPhysicsBody;
@class AHPhysicsSkeleton;


@interface BCHeroType : AHActorComponent {
    
}


#pragma mark -
#pragma mark vars


@property (nonatomic, weak) BCHeroActor *hero;


#pragma mark -
#pragma mark skin


- (void)configSkeletonSkin:(AHGraphicsSkeleton *)skeleton;
- (void)configSkeletonBody:(AHPhysicsSkeleton *)skeleton;
- (AHSkeletonConfig)graphicsConfig;
- (AHSkeletonConfig)physicsConfig;


#pragma mark -
#pragma mark secondary


- (void)tappedSecondaryAtPoint:(GLKVector2)point;


#pragma mark -
#pragma mark collision


- (BOOL)willCollideWithObstacle:(AHPhysicsBody *)obstacle;


@end
