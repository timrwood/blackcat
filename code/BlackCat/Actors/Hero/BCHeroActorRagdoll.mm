//
//  BCHeroActorRagdoll.mm
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define SECONDS_BEFORE_CAN_RESET 1.0f

#define CAMERA_JUMP_DISTANCE 4.0f


#import "AHTimeManager.h"
#import "AHSceneManager.h"
#import "AHSuperSystem.h"
#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"
#import "AHPhysicsSkeleton.h"
#import "AHGraphicsSkeleton.h"

#import "BCClassSelectionScene.h"
#import "BCGlobalManager.h"
#import "BCHeroActorRagdoll.h"
#import "BCGlobalTypes.h"

#import "BCHeroTypeBoxer.h"
#import "BCHeroTypeDetective.h"
#import "BCHeroTypeFemme.h"


@implementation BCHeroActorRagdoll


#pragma mark -
#pragma mark init


- (id)initFromSkeleton:(AHSkeleton)skeleton {
    self = [super init];
    if (self) {
        // init the type
        BCHeroType *_type;
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
        
        [[AHTimeManager manager] setWorldToRealRatio:5.0f];
        
        _ragdoll = [[AHPhysicsSkeleton alloc] initFromSkeleton:skeleton andSkeletonConfig:[_type physicsConfig]];
        
        CGRect inputRect = [[UIScreen mainScreen] bounds];
        float w = inputRect.size.width;
        inputRect.size.width = inputRect.size.height;
        inputRect.size.height = w;
        _input = [[AHInputComponent alloc] initWithScreenRect:inputRect];
        [_input setDelegate:self];
        [self addComponent:_input];
        
        _skin = [[AHGraphicsSkeleton alloc] init];
        [_skin setSkeleton:skeleton];
        [self addComponent:_skin];
        
        [_type configSkeletonSkin:_skin];
        [_skin setFromSkeletonConfig:[_type graphicsConfig]];
        [_skin setLayerIndex:GFX_LAYER_BACKGROUND];
        
        [self addComponent:_ragdoll];
        
        _creationTime = [[AHTimeManager manager] realTime];
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
    
    GLKVector2 cameraPos;
    cameraPos.x = [_ragdoll skeleton].x + 2.0f;
    cameraPos.y = [[BCGlobalManager manager] buildingHeight] - 1.0f;
    
    [[AHGraphicsManager camera] setWorldPosition:cameraPos];
}


#pragma mark -
#pragma mark touch


- (void)touchBegan {
    if ([[AHTimeManager manager] realTime] - _creationTime > SECONDS_BEFORE_CAN_RESET) {
        [[AHSceneManager manager] reset];
    }
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    [[AHSceneManager manager] reset];
    //[[AHSceneManager manager] goToScene:[[BCClassSelectionScene alloc] init]];
    [super cleanupBeforeDestruction];
}


@end
