//
//  BCCrateActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"
#import "AHContactDelegate.h"


@class AHPhysicsRect;


@interface BCCrateActor : AHActor <AHContactDelegate> {
@private;
    AHPhysicsRect *_body;
    BOOL _hasBeenUpset;
}


#pragma mark -
#pragma mark static vars


+ (float)size;


#pragma mark -
#pragma mark init


- (id)initAtPosition:(CGPoint)position;


@end
