//
//  AHAnimationTimeTrack.m
//  BlackCat
//
//  Created by Tim Wood on 1/18/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHMathUtils.h"
#import "AHAnimationTimeTrack.h"


@implementation AHAnimationTimeTrack


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)size {
    self = [super init];
    if (self) {
        _size = size;
        _times = malloc(sizeof(float) * size);
    }
    return self;
}


#pragma mark -
#pragma mark times


- (void)setTimesFromArray:(NSArray *)times {
    for (int i = 0; i < _size; i++) {
        _times[i] = [[times objectAtIndex:i] floatValue];
    }
}

- (void)setTime:(float)_time atIndex:(int)i {
    if (i < _size && i >= 0) {
        _times[i] = _time;
    }
}

- (float)indexAtTime:(float)_time {
    // handle non looped values under the minimum
    if (!_isLooped && _time <= _times[0]) {
        return 0.0f;
    }
    // handle non looped values over the maximum
    if (!_isLooped && _time >= _times[_size - 1]) {
        //dlog(@"gt last _times[_size - 1] = %F    _time = %F", _times[_size - 1], _time);
        return (float) _size;
    }
    // modulate for looping
    float _modTime = _isLooped ? fmodf(_time, _length) : _time;
    //dlog(@"mod time %F", _modTime);
    
    // handle 0 through (size - 1)
    for (int i = 1; i < _size; i++) {
        if (_times[i] > _modTime) {
            float percent = FloatPercentBetween(_times[i - 1], _times[i], _time);
            //dlog(@"loop return %F", i + percent - 1.0f);
            return i + percent - 1.0f;
        }
    }
    // handle size - 1 to 0
    float percent = FloatPercentBetween(_times[_size - 1], _times[0] + _length, _modTime);
    //dlog(@"end return %F", _size + percent);
    return _size + percent;
}


#pragma mark -
#pragma mark looped


- (void)setLoopedLength:(float)length {
    _isLooped = YES;
    _length = length;
}


@end
