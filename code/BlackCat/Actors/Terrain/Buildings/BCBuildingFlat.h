//
//  BCBuildingActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "BCBuildingType.h"


@class AHPhysicsRect;
@class AHGraphicsCube;


@interface BCBuildingFlat : BCBuildingType {
@private;
    AHPhysicsRect *_body;
    AHGraphicsCube *_skin;
}


@end
