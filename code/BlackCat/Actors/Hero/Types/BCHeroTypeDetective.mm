//
//  BCHeroTypeRunner.m
//  BlackCat
//
//  Created by Tim Wood on 2/1/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define CANNON_VELOCITY 30.0f


#import "AHActorManager.h"
#import "AHGraphicsManager.h"

#import "BCWeaponCannon.h"
#import "BCHeroTypeDetective.h"


@implementation BCHeroTypeDetective


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _timeLastTappedSecondary = 0;
    }
    return self;
}


#pragma mark -
#pragma mark skin


- (void)configSkeletonSkin:(AHGraphicsSkeleton *)skeleton {
    [skeleton setTextureKey:@"body-detective.png"];
    [skeleton setArmATextureRect:CGRectMake(0.25f, 0.0f, 0.25f, 0.5f)];
    [skeleton setArmBTextureRect:CGRectMake(0.0f, 0.0f, 0.25f, 0.5f)];
    [skeleton setLegATextureRect:CGRectMake(0.25f, 0.5f, 0.25f, 0.5f)];
    [skeleton setLegBTextureRect:CGRectMake(0.0f, 0.5f, 0.25f, 0.5f)];
    [[skeleton torso] setTex:CGRectMake(0.5f, 0.5f, 0.5f, 0.5f)];
    [[skeleton head] setTex:CGRectMake(0.5f, 0.25f, 0.5f, 0.25f)];
}

- (void)configSkeletonBody:(AHPhysicsSkeleton *)skeleton {
    
}

- (AHSkeletonConfig)graphicsConfig {
    AHSkeletonConfig config;
    config.armWidth = 0.20f;
    config.armLength = 0.9f;
    config.legWidth = 0.20f;
    config.legLength = 1.1f;
    config.torsoWidth = 0.28f;
    config.torsoHeight = 0.94f;
    config.headTop = 0.22f;
    config.headBottom = 0.08f;
    config.headLeft = 0.1f;
    config.headRight = 0.15f;
    return config;
}

- (AHSkeletonConfig)physicsConfig {
    return [self graphicsConfig];
}


#pragma mark -
#pragma mark velocity


- (GLKVector2)modifyVelocity:(GLKVector2)velocity {
    //return GLKVector2Zero();
    return velocity;
}


#pragma mark -
#pragma mark input


- (void)touchBeganAtPoint:(GLKVector2)point {
    GLKVector2 worldPoint = [[AHGraphicsManager camera] screenToWorld:point];
    GLKVector2 velocity = GLKVector2Subtract(worldPoint, [self heroPosition]);
    velocity = GLKVector2Normalize(velocity);
    velocity = GLKVector2MultiplyScalar(velocity, CANNON_VELOCITY);
    
    BCWeaponCannon *cannon = [[BCWeaponCannon alloc] initAtPosition:[self heroPosition] andVelocity:velocity];
    //BCWeaponCannon *cannon = [[BCWeaponCannon alloc] initAtPosition:worldPoint andVelocity:GLKVector2Zero()];
    [[AHActorManager manager] add:cannon];
}

#pragma mark -
#pragma mark collision


- (BOOL)willCollideWithObstacle:(AHPhysicsBody *)obstacle {
    return YES;
}


@end
