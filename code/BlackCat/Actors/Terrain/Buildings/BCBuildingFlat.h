//
//  BCBuildingActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsCube.h"
#import "BCBuildingType.h"


@class AHPhysicsRect;


@interface BCBuildingFlat : BCBuildingType {
@private;
    AHPhysicsRect *_body;
    AHGraphicsCube *_skin;
    
    AHGraphicsCube *cube;
    
    float rotation;
}


@end
