//
//  BCBlockableObstacle.h
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsCube.h"
#import "AHActor.h"


@interface BCCrashableObstacle : AHActor {
@private;
    AHGraphicsCube *_frontSkin;
    AHGraphicsCube *_backSkin;
}


#pragma mark -
#pragma mark init


- (id)initAtBottomCenterPoint:(GLKVector2)bottomCenter;


@end
