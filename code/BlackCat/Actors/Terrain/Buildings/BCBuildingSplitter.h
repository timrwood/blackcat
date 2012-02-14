//
//  BCBuildingSplitter.h
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHGraphicsCube.h"
#import "BCBuildingType.h"


@class AHPhysicsRect;
@class AHPhysicsPolygon;


@interface BCBuildingSplitter : BCBuildingType {
@private;
    AHPhysicsPolygon *_stairCeiling;
    AHPhysicsPolygon *_step1;
    AHPhysicsRect *_stairCeilingEnd;
    AHPhysicsRect *_step2;
    
    AHGraphicsCube *_skin1;
    AHGraphicsCube *_skin2;
    AHGraphicsCube *_skinCeiling1;
    AHGraphicsCube *_skinCeiling2;
    AHGraphicsCube *_skinCeiling3;
    AHGraphicsCube *_skinBack;
    AHGraphicsCube *_skinStair;
    
    BOOL _step1to2isUp;
    BOOL _step2to3isUp;
}


#pragma mark -
#pragma mark setup


- (void)setupStep1;
- (void)setupStep2;
- (void)setupStairCeiling;
- (void)setupStairCeilingMiddle;
- (void)setupStairCeilingEnd;
- (void)setupStepBack;
- (void)setupStairSteps;


@end
