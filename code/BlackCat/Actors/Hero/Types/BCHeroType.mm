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
