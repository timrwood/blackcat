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
        //dlog(@"destroyActor");
        [body destroyActor];
    }
}

- (void)cleanupWorld {
    //dlog(@"cleanup world");
    CGPoint size = CGPointMake(200.0f, 200.0f);
    float cameraX = [[AHGraphicsManager camera] worldPosition].x;
    [self cleanupWorldAtPoint:CGPointMake(cameraX, 290.0f) andSize:size];
    [self cleanupWorldAtPoint:CGPointMake(cameraX - 290.0f, 0.0f) andSize:size];
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
