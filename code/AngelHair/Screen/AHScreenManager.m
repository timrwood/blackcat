//
//  AHScreenManager.m
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHScreenManager.h"


static AHScreenManager *_manager = nil;


@implementation AHScreenManager


#pragma mark -
#pragma mark singleton


+ (AHScreenManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        float w = screen.size.width;
        screen.size.width = screen.size.height;
        screen.size.height = w;
        _screen = screen;
    }
    return self;
}


#pragma mark -
#pragma mark screen rect


- (CGRect)screenRect {
    return _screen;
}

- (float)screenHeight {
    return _screen.size.height;
}

- (float)screenWidth {
    return _screen.size.width;
}


@end
