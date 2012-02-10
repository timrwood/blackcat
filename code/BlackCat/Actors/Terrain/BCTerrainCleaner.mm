//
//  BCTerrainCleaner.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHPhysicsBody.h"
#import "AHPhysicsManager.h"
#import "AHPhysicsManagerCPP.h"
#import "AHGraphicsManager.h"
#import "AHGraphicsCamera.h"

#import "BCGlobalManager.h"
#import "BCTerrainCleaner.h"


#define FRAMES_BETWEEN_CLEANUP 5

#define METERS_BEHIND_HERO_TO_CLEANUP 100.0f
#define METERS_BELOW_HERO_TO_CLEANUP 25.0f


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


- (void)cleanupWorld {
    float buildingHeight = [[BCGlobalManager manager] buildingHeight];
    float cameraX = [[BCGlobalManager manager] heroPosition].x;
    for (b2Body *body = [[AHPhysicsManager cppManager] world]->GetBodyList(); body; body = body->GetNext()) {
        b2Vec2 pos = body->GetPosition();
        AHPhysicsBody *wrapper = (__bridge AHPhysicsBody *) body->GetUserData();
		if (pos.x < cameraX - METERS_BEHIND_HERO_TO_CLEANUP || pos.y > buildingHeight + METERS_BELOW_HERO_TO_CLEANUP) {
            [wrapper destroyActor];
        }
	}
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
