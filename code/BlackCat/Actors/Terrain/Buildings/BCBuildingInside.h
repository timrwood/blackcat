//
//  BCBuildingActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "BCBuildingType.h"


@class AHPhysicsRect;
@class AHPhysicsPolygon;
@class AHGraphicsCube;


@interface BCBuildingInside : BCBuildingType {
@private;
    AHPhysicsPolygon *_bodyTop;
    AHPhysicsRect *_bodyBot;
    
    AHGraphicsCube *_skinTop;
    AHGraphicsCube *_skinBot;
}


@end
