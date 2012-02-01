//
//  BCBackgroundActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActor.h"


@class AHGraphicsRect;


@interface BCBackgroundActor : AHActor {
@private;
    AHGraphicsRect *_top;
    AHGraphicsRect *_mid;
    AHGraphicsRect *_bot;
    
    CGSize topMidTexSize;
    CGSize bottomTexSize;
}


#pragma mark -
#pragma mark update


- (void)updatePosition;
- (void)updateTexture;


@end
