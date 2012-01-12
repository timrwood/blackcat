//
//  BCBuildingActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@class AHPhysicsRect;


@interface BCBuildingActor : AHActor {
@private;
    AHPhysicsRect *_body;
}


#pragma mark -
#pragma mark init


- (id)initFromSize:(CGPoint)size andPosition:(CGPoint)position;


@end
