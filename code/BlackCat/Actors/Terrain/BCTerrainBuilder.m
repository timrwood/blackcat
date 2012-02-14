//
//  BCTerrainBuilder.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define GAP_ADDITION_LERPING 2.0f


#import "AHMathUtils.h"
#import "AHActorManager.h"
#import "AHGraphicsCamera.h"
#import "AHGraphicsManager.h"

#import "BCTerrainBuilder.h"
#import "BCCrateActor.h"
#import "BCGlobalManager.h"

#import "BCBuildingType.h"
#import "BCBuildingFlat.h"
#import "BCBuildingInside.h"
#import "BCBuildingThreeStepped.h"
#import "BCBuildingSplitter.h"
#import "BCBuildingMultiLevel.h"


@implementation BCTerrainBuilder


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _randKey = rand();
        _randOffset = 0;
        _buildingOffset = BUILDING_FLAT_ORIGIN;
        [self buildBuilding];
    }
    return self;
}

- (id)initWithKey:(int)key {
    self = [super init];
    if (self) {
        _randKey = key;
        _randOffset = 0;
        _buildingOffset = BUILDING_FLAT_ORIGIN;
        [self buildBuilding];
    }
    return self;
}


#pragma mark -
#pragma mark build


- (void)buildBuilding {
    [self buildBuildingWithType:_buildingOffset];
    
    // increment buildings
    _buildingOffset ++;
    if (_buildingOffset >= BUILDING_TYPE_LENGTH) {
        _buildingOffset = BUILDING_FLAT;
    }
    
    // random building
    _buildingOffset = [self seededRandomBetweenFloat:1 andFloat:BUILDING_TYPE_LENGTH];
    if (_buildingOffset == BUILDING_TYPE_LENGTH) {
        _buildingOffset--;
    }
    
    //if (_buildingOffset == BUILDING_SPLITTER) {
    //    _buildingOffset--;
    //}
    
    // same building
    _buildingOffset = BUILDING_MULTI_LEVEL;
}

- (void)buildBuildingWithType:(BCBuildingTypes)type {
    GLKVector2 lastEnd = GLKVector2Make(0.0f, 0.0f);
    if (_nextBuilding) {
        lastEnd = [_nextBuilding endCorner];
    }
    
    float spacing = 0.0f;
    float nextHeight = [self seededRandomBetweenFloat:0.0f andFloat:0.0f];
    
    BCBuildingType *newBuilding;
    switch (type) {
        case BUILDING_FLAT_ORIGIN:
            spacing = -2.0f;
            nextHeight = 1.0f;
            newBuilding = [[BCBuildingFlat alloc] init];
            break;
        case BUILDING_FLAT:
            newBuilding = [[BCBuildingFlat alloc] init];
            break;
        case BUILDING_THREE_STEPPED_101:
            newBuilding = [[BCBuildingThreeStepped alloc] init];
            [(BCBuildingThreeStepped *)newBuilding setStep1to2Up:NO];
            [(BCBuildingThreeStepped *)newBuilding setStep2to3Up:YES];
            break;
        case BUILDING_THREE_STEPPED_121:
            newBuilding = [[BCBuildingThreeStepped alloc] init];
            [(BCBuildingThreeStepped *)newBuilding setStep1to2Up:YES];
            [(BCBuildingThreeStepped *)newBuilding setStep2to3Up:NO];
            break;
        case BUILDING_THREE_STEPPED_012:
            newBuilding = [[BCBuildingThreeStepped alloc] init];
            [(BCBuildingThreeStepped *)newBuilding setStep1to2Up:YES];
            [(BCBuildingThreeStepped *)newBuilding setStep2to3Up:YES];
            break;
        case BUILDING_THREE_STEPPED_210:
            newBuilding = [[BCBuildingThreeStepped alloc] init];
            [(BCBuildingThreeStepped *)newBuilding setStep1to2Up:NO];
            [(BCBuildingThreeStepped *)newBuilding setStep2to3Up:NO];
            break;
        case BUILDING_INSIDE:
            newBuilding = [[BCBuildingInside alloc] init];
            break;
        case BUILDING_SPLITTER:
            newBuilding = [[BCBuildingSplitter alloc] init];
            break;
        case BUILDING_MULTI_LEVEL:
            newBuilding = [[BCBuildingMultiLevel alloc] init];
            break;
        case BUILDING_TYPE_LENGTH:
            dlog(@"Trying to make a building with an unknown type : BUILDING_TYPE_LENGTH");
            return;
        default:
            dlog(@"Trying to make a building with an unknown type : default");
            return;
    }
    [newBuilding setStartCorner:GLKVector2Add(GLKVector2Make(spacing, nextHeight), lastEnd)];
    [[AHActorManager manager] add:newBuilding];
    
    if (_nextBuilding) {
        _currentBuilding = _nextBuilding;
    }
    _nextBuilding = newBuilding;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    [self updateBuildingHeight];
}

- (void)updateBuildingHeight {
    float buildingX = [[BCGlobalManager manager] buildingHeightXPosition];
    float buildingHeight = 0.0f;
    
    GLKVector2 curEnd;
    GLKVector2 nextStart;
    
    if (_nextBuilding) {
        nextStart = [_nextBuilding startCorner];
    } else {
        //dlog(@"no next building, building one now");
        [self buildBuilding];
        return;
    }
    
    if (_currentBuilding) {
        curEnd = [_currentBuilding endCorner];
    } else {
        //dlog(@"no current building, building one now");
        [self buildBuilding];
        return;
    }
    
    if (buildingX < curEnd.x - GAP_ADDITION_LERPING) {
        buildingHeight = [_currentBuilding heightAtXPosition:buildingX];
    } else if (buildingX < nextStart.x + GAP_ADDITION_LERPING) {
        float percent = (buildingX - (curEnd.x - GAP_ADDITION_LERPING)) / ((nextStart.x + GAP_ADDITION_LERPING) - (curEnd.x - GAP_ADDITION_LERPING));
        buildingHeight = FloatLerp(curEnd.y, nextStart.y, percent);
    } else {
        buildingHeight = [_nextBuilding heightAtXPosition:buildingX];
        [self buildBuilding];
    }
    
    /*
    if (heroX > nextStart.x) {
        [self buildBuilding];
    }*/
    
    [[BCGlobalManager manager] setBuildingHeight:buildingHeight];
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
