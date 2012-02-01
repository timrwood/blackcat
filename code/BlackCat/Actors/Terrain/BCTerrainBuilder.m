//
//  BCTerrainBuilder.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHMathUtils.h"
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
        _randKey = rand();
        _randOffset = 0;
        [self buildBuildingWithSize:CGSizeMake(5.0f, 0.0f)];
    }
    return self;
}

- (id)initWithKey:(int)key {
    self = [super init];
    if (self) {
        _randKey = key;
        _randOffset = 0;
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
    
    GLKVector2 pos = GLKVector2Make([_currentBuilding distanceCovered] + buildingSpacing + size.width / 2.0f, 5.0f - size.height);
    CGSize bSize = CGSizeMake(size.width / 2.0f, 5.0f);
    
    _nextBuilding = [[BCBuildingActor alloc] initFromSize:bSize andPosition:pos];
    [_nextBuilding setSpacing:buildingSpacing];
    [_nextBuilding setPrevHeight:[_currentBuilding height]];
    _lastBuildingHeight = size.height;
    [[AHActorManager manager] add:_nextBuilding];
    
    pos.x += size.width * [self seededRandomBetweenFloat:-0.3f andFloat:0.3f];
    pos.y = -size.height;
    [self buildCratesAtPosition:pos];
}

- (void)buildBuilding {
    float buildingWidth = [self seededRandomBetweenFloat:5.0f andFloat:20.0f] + [[BCGlobalManager manager] heroSpeed];
    float minBuildingHeight = fmaxf(0.0f, _lastBuildingHeight - 2.0f);
    float maxBuildingHeight = fminf(5.0f, _lastBuildingHeight + 2.0f);
    float buildingHeight = [self seededRandomBetweenFloat:minBuildingHeight andFloat:maxBuildingHeight];
    [self buildBuildingWithSize:CGSizeMake(buildingWidth, buildingHeight)];
}

- (void)buildCratesAtPosition:(GLKVector2)position {
    float size = [BCCrateActor size];
    
    GLKVector2 pos = position;
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


#pragma mark -
#pragma mark rand


- (float)seededPercent {
    _randOffset++;
    if (_randOffset > 100) {
        _randOffset = 0;
    }
    int mod = (_randOffset * 3 + 20);
    return (float) (_randKey % mod) / (float) mod;
}

- (float)seededRandomBetweenFloat:(float)a andFloat:(float)b {
    float percent = [self seededPercent];
    return FloatLerp(a, b, percent);
}


@end
