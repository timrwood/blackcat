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
}


#pragma mark -
#pragma mark build


- (void)buildBuildingWithSize:(CGSize)size;
- (void)buildBuilding;
- (void)buildCratesAtPosition:(CGPoint)position;


@end
