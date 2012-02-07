//
//  BCBuildingSplitter.h
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCBuildingType.h"


@class AHGraphicsRect;
@class AHPhysicsRect;
@class AHPhysicsPolygon;


@interface BCBuildingSplitter : BCBuildingType {
@private;
    AHPhysicsPolygon *_stairCeiling;
    AHPhysicsPolygon *_step1;
    AHPhysicsRect *_stairCeilingEnd;
    AHPhysicsRect *_step2;
    
    AHGraphicsRect *_skin1;
    AHGraphicsRect *_skin2;
    AHGraphicsRect *_skinCeiling1;
    AHGraphicsRect *_skinCeiling2;
    
    BOOL _step1to2isUp;
    BOOL _step2to3isUp;
}


#pragma mark -
#pragma mark setup


- (void)setupStep1;
- (void)setupStep2;
- (void)setupStairCeiling;
- (void)setupStairCeilingEnd;


@end
