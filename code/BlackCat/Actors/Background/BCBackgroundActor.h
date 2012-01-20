//
//  BCBackgroundActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@class AHGraphicsRect;


@interface BCBackgroundActor : AHActor {
@private;
    AHGraphicsRect *_top;
    AHGraphicsRect *_mid;
    AHGraphicsRect *_bot;
}


@end
