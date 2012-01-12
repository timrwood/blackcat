//
//  AHInputTouch.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHInputTouch.h"


@implementation AHInputTouch


#pragma mark -
#pragma mark init


- (id)initWithUITouch:(UITouch *)newTouch {
	self = [super init];
	if (self) {
        touch = newTouch;
	}
	return self;
}


#pragma mark -
#pragma mark touch


- (void)touchStartedAtScreenPosition:(CGPoint)position {
    
}

- (void)touchMovedToScreenPosition:(CGPoint)position {
    
}

- (void)touchEnded {
    
}


@end
