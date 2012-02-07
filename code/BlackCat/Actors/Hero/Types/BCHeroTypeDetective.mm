//
//  BCHeroTypeRunner.m
//  BlackCat
//
//  Created by Tim Wood on 2/1/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHSkeletonStruct.h"
#import "AHGraphicsSkeleton.h"
#import "AHGraphicsRect.h"

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
#pragma mark vars


@synthesize hero;


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
    config.armWidth = 0.15f;
    config.armLength = 0.9f;
    config.legWidth = 0.15f;
    config.legLength = 1.0f;
    config.torsoWidth = 0.25f;
    config.torsoHeight = 0.6f;
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
#pragma mark secondary


- (void)tappedSecondaryAtPoint:(GLKVector2)point {
    
}


#pragma mark -
#pragma mark collision


- (BOOL)willCollideWithObstacle:(AHPhysicsBody *)obstacle {
    return YES;
}


@end
