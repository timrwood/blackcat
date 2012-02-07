//
//  BCHeroType.m
//  BlackCat
//
//  Created by Tim Wood on 2/1/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsSkeleton.h"
#import "AHPhysicsBody.h"
#import "AHPhysicsSkeleton.h"
#import "BCHeroType.h"


@implementation BCHeroType


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark vars


@synthesize hero;


#pragma mark -
#pragma mark skin


- (void)configSkeletonSkin:(AHGraphicsSkeleton *)skeleton {
    
}

- (void)configSkeletonBody:(AHPhysicsSkeleton *)skeleton {
    
}

- (AHSkeletonConfig)graphicsConfig {
    AHSkeletonConfig _config;
    return _config;
}

- (AHSkeletonConfig)physicsConfig {
    AHSkeletonConfig _config;
    return _config;
}

- (AHSkeleton)upperLimit {
    AHSkeleton upper;
    upper.hipA = M_TAU_16;
    upper.hipB = M_TAU_16;
    upper.kneeA = M_TAU_4 + M_TAU_8;
    upper.kneeB = M_TAU_4 + M_TAU_8;
    upper.elbowA = 0.0f;
    upper.elbowB = 0.0f;
    upper.shoulderA = M_TAU_4;
    upper.shoulderB = M_TAU_4;
    upper.neck = M_TAU_16;
    
    return upper;
}

- (AHSkeleton)lowerLimit {
    AHSkeleton lower;
    lower.hipA = -(M_TAU_4 + M_TAU_8);
    lower.hipB = -(M_TAU_4 + M_TAU_8);
    lower.kneeA = 0.0f;
    lower.kneeB = 0.0f;
    lower.elbowA = -(M_TAU_4 + M_TAU_8);
    lower.elbowB = -(M_TAU_4 + M_TAU_8);
    lower.shoulderA = -M_TAU_2;
    lower.shoulderB = -M_TAU_2;
    lower.neck = -M_TAU_16;
    
    return lower;
}


#pragma mark -
#pragma mark secondary


- (void)tappedSecondaryAtPoint:(GLKVector2)point {
    
}


#pragma mark -
#pragma mark collision


- (BOOL)willCollideWithAnyObstacle {
    return YES;
}

- (BOOL)willCollideWithObstacle:(AHPhysicsBody *)obstacle {
    return [self willCollideWithAnyObstacle];
}


@end
