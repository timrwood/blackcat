//
//  BCTerrainBuilder.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


typedef enum {
    BUILDING_FLAT_ORIGIN,
    BUILDING_FLAT,
    BUILDING_THREE_STEPPED_101,
    BUILDING_THREE_STEPPED_121,
    BUILDING_THREE_STEPPED_012,
    BUILDING_THREE_STEPPED_210,
    BUILDING_INSIDE,
    BUILDING_TYPE_LENGTH
} BCBuildingTypes;


#import "AHActor.h"


@class BCBuildingType;


@interface BCTerrainBuilder : AHActor {
@private;
    BCBuildingType *_currentBuilding;
    BCBuildingType *_nextBuilding;
    
    int _buildingOffset;
    
    int _randKey;
    int _randOffset;
}


#pragma mark -
#pragma mark init


- (id)initWithKey:(int)key;


#pragma mark -
#pragma mark build


- (void)buildBuilding;
- (void)buildBuildingWithType:(BCBuildingTypes)type;


#pragma mark -
#pragma mark update


- (void)updateBuildingHeight;


#pragma mark -
#pragma mark rand


- (float)seededPercent;
- (float)seededRandomBetweenFloat:(float)a andFloat:(float)b;


@end
