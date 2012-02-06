//
//  BCBuildingActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "BCBuildingType.h"


@class AHPhysicsRect;
@class AHGraphicsRect;


@interface BCBuildingInside : BCBuildingType {
@private;
    AHPhysicsRect *_bodyTop;
    AHPhysicsRect *_bodyBot;
    
    AHGraphicsRect *_skinTop;
    AHGraphicsRect *_skinBot;
}


@end
