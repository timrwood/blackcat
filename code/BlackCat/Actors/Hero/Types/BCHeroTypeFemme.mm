//
//  BCHeroTypeFemme.mm
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define TIME_TO_GHOST_WALK 1.0f

#import "AHTimeManager.h"

#import "BCHeroTypeFemme.h"


@implementation BCHeroTypeFemme


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
    [skeleton setTextureKey:@"body-femme.png"];
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
    config.legLength = 1.0f;
    config.torsoWidth = 0.28f;
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
    _timeLastTappedSecondary = [[AHTimeManager manager] realTime];
}


#pragma mark -
#pragma mark collision


- (BOOL)willCollideWithAnyObstacle {
    if ([[AHTimeManager manager] realTime] - _timeLastTappedSecondary < TIME_TO_GHOST_WALK) {
        return NO;
    }
    return YES;
}


@end
