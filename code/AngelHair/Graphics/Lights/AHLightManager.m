//
//  AHLightManager.m
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHShaderManager.h"
#import "AHLightManager.h"


static AHLightManager *_manager = nil;


@implementation AHLightManager


#pragma mark -
#pragma mark singleton


+ (AHLightManager *)manager {
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
        [self setPosition:GLKVector3Make(-0.2f, 1.0f, 0.5f)];
    }
    return self;
}


#pragma mark -
#pragma mark move light


- (void)setPosition:(GLKVector3)position {
    _lightPosition = position;
}

- (void)updatePosition {
    [[AHShaderManager manager] setLightPosition:_lightPosition];
}


@end
