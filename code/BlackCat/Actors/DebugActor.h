//
//  DebugActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@class AHPhysicsRect;


@interface DebugActor : AHActor {
@private;
    AHPhysicsRect *_body;
}


@end
