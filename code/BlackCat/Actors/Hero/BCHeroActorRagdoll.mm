//
//  BCHeroActorRagdoll.mm
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"
#import "AHPhysicsSkeleton.h"
#import "AHGraphicsSkeleton.h"

#import "BCHeroActorRagdoll.h"
#import "BCGlobalTypes.h"


@implementation BCHeroActorRagdoll


#pragma mark -
#pragma mark init


- (id)initFromSkeleton:(AHSkeleton)skeleton andSkeletonConfig:(AHSkeletonConfig)config {
    self = [super init];
    if (self) {
        _ragdoll = [[AHPhysicsSkeleton alloc] initFromSkeleton:skeleton andSkeletonConfig:config];
        
        _skin = [[AHGraphicsSkeleton alloc] init];
        [_skin setFromSkeletonConfig:config];
        [_skin setSkeleton:skeleton];
        [_skin setTextureKey:@"debug-grid.png"];
        [_skin setArmsTextureRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setLegsTextureRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [[_skin torso] setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [[_skin head] setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        
        [[AHGraphicsManager manager] addObject:_skin toLayerIndex:GFX_LAYER_BACKGROUND];
        [self addComponent:_skin];
        [self addComponent:_ragdoll];
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    [_skin setSkeleton:[_ragdoll skeleton]];
}


@end
