//
//  BCTerrainBuilder.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@class BCBuildingActor;


@interface BCTerrainBuilder : AHActor {
@private;
    BCBuildingActor *_currentBuilding;
    BCBuildingActor *_nextBuilding;
    int _randKey;
    int _randOffset;
    
    float _lastBuildingHeight;
}


#pragma mark -
#pragma mark init


- (id)initWithKey:(int)key;


#pragma mark -
#pragma mark build


- (void)buildBuildingWithSize:(CGSize)size;
- (void)buildBuilding;
- (void)buildCratesAtPosition:(CGPoint)position;


#pragma mark -
#pragma mark rand


- (float)seededPercent;
- (float)seededRandomBetweenFloat:(float)a andFloat:(float)b;


@end
