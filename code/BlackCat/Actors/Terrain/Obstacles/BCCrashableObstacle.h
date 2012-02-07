//
//  BCBlockableObstacle.h
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsRect.h"
#import "AHActor.h"


@class AHPhysicsRect;


@interface BCCrashableObstacle : AHActor {
@private;
    AHPhysicsRect *_body;
    AHGraphicsRect *_skin;
}


#pragma mark -
#pragma mark init


- (id)initAtBottomCenterPoint:(GLKVector2)bottomCenter;


@end
