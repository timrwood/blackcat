//
//  BCTerrainBuilder.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorManager.h"
#import "AHGraphicsCamera.h"
#import "AHGraphicsManager.h"

#import "BCTerrainBuilder.h"
#import "BCBuildingActor.h"
#import "BCCrateActor.h"
#import "BCGlobalManager.h"


@implementation BCTerrainBuilder


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self buildBuildingWithSize:CGSizeMake(5.0f, 0.0f)];
    }
    return self;
}


#pragma mark -
#pragma mark build


- (void)buildBuildingWithSize:(CGSize)size {
    // set the next building to the current building
    _currentBuilding = _nextBuilding;
    
    float buildingSpacing = [[BCGlobalManager manager] heroSpeed] * 0.5f;
    
    CGPoint pos = CGPointMake([_currentBuilding distanceCovered] + buildingSpacing + size.width / 2.0f, 5.0f - size.height);
    CGSize bSize = CGSizeMake(size.width / 2.0f, 5.0f);
    
    _nextBuilding = [[BCBuildingActor alloc] initFromSize:bSize andPosition:pos];
    [_nextBuilding setSpacing:buildingSpacing];
    [_nextBuilding setPrevHeight:[_currentBuilding height]];
    [[AHActorManager manager] add:_nextBuilding];
    
    pos.x += size.width * (0.4f - (0.08f * (rand() % 10)));
    pos.y = -size.height;
    [self buildCratesAtPosition:pos];
}

- (void)buildBuilding {
    float buildingWidth = 5.0f + rand() % 15 + [[BCGlobalManager manager] heroSpeed];
    float buildingHeight = (float)(rand() % 5);
    [self buildBuildingWithSize:CGSizeMake(buildingWidth, buildingHeight)];
}

- (void)buildCratesAtPosition:(CGPoint)position {
    float size = [BCCrateActor size];
    
    CGPoint pos = position;
    pos.y -= size;
    [[AHActorManager manager] add:[[BCCrateActor alloc] initAtPosition:pos]];
    
    pos.x -= size * 2;
    [[AHActorManager manager] add:[[BCCrateActor alloc] initAtPosition:pos]];
    
    pos.x += size * 4;
    [[AHActorManager manager] add:[[BCCrateActor alloc] initAtPosition:pos]];
    
    pos.x -= size;
    pos.y -= size * 2;
    [[AHActorManager manager] add:[[BCCrateActor alloc] initAtPosition:pos]];
    
    pos.x -= size * 2;
    [[AHActorManager manager] add:[[BCCrateActor alloc] initAtPosition:pos]];
    
    pos.x += size;
    pos.y -= size * 4;
    [[AHActorManager manager] add:[[BCCrateActor alloc] initAtPosition:pos]];
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    float heroX = [[BCGlobalManager manager] heroPosition].x;
    
    if ([_currentBuilding distanceCovered] > heroX) {
        [[BCGlobalManager manager] setBuildingHeight:[_currentBuilding heightAtPosition:heroX]];
        //dlog(@"building height %F", [_currentBuilding heightAtPosition:heroX]);
    } else {
        [self buildBuilding];
    }
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    _currentBuilding = nil;
    _nextBuilding = nil;
}


@end
