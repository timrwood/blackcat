//
//  AHAnimationTrack.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHAnimationTrack.h"


@interface AHAnimationTrack()


- (void)cacheTime:(float)time;


@end


@implementation AHAnimationTrack


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)newSize {
    self = [super init];
    if (self) {
        size = newSize;
    }
    return self;
}


#pragma mark -
#pragma mark time


- (void)setTimeTrack:(AHAnimationTimeTrack *)timeTrack {
    _timeTrack = timeTrack;
}

- (int)indexAAtTime:(float)time {
    if (_lastTime != time) {
        [self cacheTime:time];
    }
    return _lastIndexA;
}

- (int)indexBAtTime:(float)time {
    if (_lastTime != time) {
        [self cacheTime:time];
    }
    return _lastIndexA == (size - 1) ? 0 : _lastIndexA + 1;
}

- (float)percentAtTime:(float)time {
    if (_lastTime != time) {
        [self cacheTime:time];
    }
    return _lastPercent;
}


#pragma mark -
#pragma mark private methods


- (void)cacheTime:(float)time {
    float value = [_timeTrack indexAtTime:time];
    
    _lastTime = time;
    _lastIndexA = value;
    _lastPercent = value - _lastIndexA;
}


@end
