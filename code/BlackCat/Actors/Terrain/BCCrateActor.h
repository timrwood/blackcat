//
//  BCCrateActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActor.h"
#import "AHContactDelegate.h"


@class AHPhysicsRect;
@class AHGraphicsRect;


@interface BCCrateActor : AHActor <AHContactDelegate> {
@private;
    AHGraphicsRect *_skin;
    AHPhysicsRect *_body;
    BOOL _hasBeenUpset;
}


#pragma mark -
#pragma mark static vars


+ (float)size;


#pragma mark -
#pragma mark init


- (id)initAtPosition:(GLKVector2)position;


@end
