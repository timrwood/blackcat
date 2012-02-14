//
//  BCTerrainCleaner.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActorManager.h"
#import "AHPhysicsBody.h"
#import "AHPhysicsManager.h"
#import "AHPhysicsManagerCPP.h"
#import "AHGraphicsManager.h"
#import "AHGraphicsCamera.h"

#import "BCGlobalManager.h"
#import "BCTerrainCleaner.h"


#define FRAMES_BETWEEN_CLEANUP 10

#define METERS_BEHIND_HERO_TO_CLEANUP 10.0f
#define METERS_BELOW_HERO_TO_CLEANUP 20.0f


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
        AHPhysicsBody *wrapper = (__bridge AHPhysicsBody *) body->GetUserData();
        float radius = [wrapper radius];
        GLKVector2 pos = GLKVector2Add([wrapper position], GLKVector2Make(radius, -radius));
        
		if (pos.x < cameraX - METERS_BEHIND_HERO_TO_CLEANUP || 
            pos.y > buildingHeight + METERS_BELOW_HERO_TO_CLEANUP) {
            [wrapper destroyActor];
        }
	}
    
    dlog(@"total bodies : %i", [[AHPhysicsManager cppManager] world]->GetBodyCount());
    dlog(@"total actors : %i", [[AHActorManager manager] count]);
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
