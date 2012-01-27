//
//  BCHeroActorRagdoll.h
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@class AHPhysicsSkeleton;
@class AHGraphicsSkeleton;


@interface BCHeroActorRagdoll : AHActor {
@private;
    AHPhysicsSkeleton *_ragdoll;
    AHGraphicsSkeleton *_skin;
}


#pragma mark -
#pragma mark init


- (id)initFromSkeleton:(AHSkeleton)skeleton
     andSkeletonConfig:(AHSkeletonConfig)config;


@end
