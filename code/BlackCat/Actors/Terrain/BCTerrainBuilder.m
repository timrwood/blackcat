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
        _distanceCovered = 0.0f;
        [self buildBuildingWithSize:CGSizeMake(50.0f, 0.0f)];
    }
    return self;
}


#pragma mark -
#pragma mark build


- (void)buildBuildingWithSize:(CGSize)size {
    float buildingSpacing = [[BCGlobalManager manager] heroSpeed] * 0.5f;
    
    CGPoint pos = CGPointMake(_distanceCovered + buildingSpacing + size.width / 2.0f, 5.0f - size.height);
    CGSize bSize = CGSizeMake(size.width / 2.0f, 5.0f);
    
    BCBuildingActor *building = [[BCBuildingActor alloc] initFromSize:bSize andPosition:pos];
    [[AHActorManager manager] add:building];
    _distanceCovered += size.width + buildingSpacing;
    
    pos.x += size.width * (0.4f - (0.08f * (rand() % 10)));
    pos.y = -size.height;
    [self buildCratesAtPosition:pos];
}

- (void)buildBuilding {
    float buildingWidth = 15.0f + rand() % 15;
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
    float cameraX = [[AHGraphicsManager camera] worldPosition].x;

    if (_distanceCovered < cameraX + 30.0f) {
        [self buildBuilding];
    }
}


@end
