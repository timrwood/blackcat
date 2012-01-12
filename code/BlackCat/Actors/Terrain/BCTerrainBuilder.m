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


@implementation BCTerrainBuilder


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _distanceCovered = 0.0f;
    }
    return self;
}


#pragma mark -
#pragma mark build


- (void)buildBuilding {
    float buildingWidth = 3.0f + rand() % 6;
    float buildingHeight = 1.0f - (float)(rand() % 8) / 12.0f;
    
    CGPoint pos = CGPointMake(_distanceCovered + buildingWidth / 2.0f, - 3.0f + buildingHeight);
    CGPoint size = CGPointMake(buildingWidth / 2.0f, buildingHeight);
    
    BCBuildingActor *building = [[BCBuildingActor alloc] initFromSize:size andPosition:pos];
    [[AHActorManager manager] add:building];
    _distanceCovered += buildingWidth;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    float cameraX = [[[AHGraphicsManager manager] camera] worldPosition].x;

    if (_distanceCovered < cameraX + 30.0f) {
        [self buildBuilding];
    }
}


@end
