//
//  AHTimeManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHTimeManager.h"


static AHTimeManager *_manager = nil;


@implementation AHTimeManager


#pragma mark -
#pragma mark singleton


+ (AHTimeManager *)manager {
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
        _ratio = 1.0f;
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark reset


- (void)reset {
    _worldTime = 0.0f;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


#pragma mark -
#pragma mark update


- (void)update {
    _worldTime += _ratio / _framesPerSecond;
    _realTime += 1.0f / _framesPerSecond;
}


#pragma mark -
#pragma mark frames


- (float)worldTime {
    return _worldTime;
}

- (float)realTime {
    return _realTime;
}

- (void)setWorldToRealRatio:(float)ratio {
    _ratio = ratio;
}

- (void)setFramesPerSecond:(float)framesPerSecond {
    _framesPerSecond = framesPerSecond;
    dlog(@"Using %i FPS", (int)framesPerSecond);
}

- (float)realFramesPerSecond {
    return _framesPerSecond;
}

- (float)realSecondsPerFrame {
    return 1.0f / _framesPerSecond;
}

- (float)worldFramesPerSecond {
    return _framesPerSecond * _ratio;
}

- (float)worldSecondsPerFrame {
    return 1.0f / (_framesPerSecond * _ratio);
}


@end
