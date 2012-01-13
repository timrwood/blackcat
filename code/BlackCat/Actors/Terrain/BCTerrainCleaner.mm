//
//  BCTerrainCleaner.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"
#import "AHPhysicsManager.h"
#import "AHPhysicsManagerCPP.h"
#import "AHGraphicsManager.h"
#import "AHGraphicsCamera.h"

#import "BCGlobalManager.h"
#import "BCTerrainCleaner.h"


#define FRAMES_BETWEEN_CLEANUP 5


@implementation BCTerrainCleaner


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark build


- (void)cleanupWorldAtPoint:(CGPoint)point andSize:(CGPoint)size {
    NSMutableArray *actors = [[AHPhysicsManager cppManager] getActorsAtPoint:point withSize:size];
    for (AHPhysicsBody *body in actors) {
        [body destroyActor];
    }
}

- (void)cleanupWorld {
    float cameraX = [[BCGlobalManager manager] heroPosition].x;
    [self cleanupWorldAtPoint:CGPointMake(cameraX, 2025.0f) andSize:CGPointMake(4000.0f, 2000.0f)];
    [self cleanupWorldAtPoint:CGPointMake(cameraX - 2200.0f, 0.0f) andSize:CGPointMake(2000.0f, 4000.0f)];
}


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    _updatesSinceLastCleanup ++;
    if (_updatesSinceLastCleanup > FRAMES_BETWEEN_CLEANUP) {
        _updatesSinceLastCleanup = 0;
        [self cleanupWorld];
    }
}


@end
