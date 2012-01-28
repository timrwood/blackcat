//
//  BCHeroActorRagdoll.mm
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSceneManager.h"
#import "AHSuperSystem.h"
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
        
        CGRect inputRect = [[UIScreen mainScreen] bounds];
        float w = inputRect.size.width;
        inputRect.size.width = inputRect.size.height;
        inputRect.size.height = w;
        _input = [[AHInputComponent alloc] initWithScreenRect:inputRect];
        [_input setDelegate:self];
        [self addComponent:_input];
        
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
#pragma mark limits


- (void)setUpperLimits:(AHSkeleton)upper 
        andLowerLimits:(AHSkeleton)lower {
    [_ragdoll setUpperLimits:upper andLowerLimits:lower];
}


#pragma mark -
#pragma mark velocity


- (void)setLinearVelocity:(GLKVector2)velocity {
    [_ragdoll setLinearVelocity:velocity];
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    [_skin setSkeleton:[_ragdoll skeleton]];
}


#pragma mark -
#pragma mark touch


- (void)touchBegan {
    [[AHSceneManager manager] reset];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    [[AHSceneManager manager] reset];
    [super cleanupBeforeDestruction];
}


@end