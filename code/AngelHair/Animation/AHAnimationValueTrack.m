//
//  AHAnimationTrack.m
//  BlackCat
//
//  Created by Tim Wood on 1/18/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHMathUtils.h"
#import "AHAnimationValueTrack.h"


@implementation AHAnimationValueTrack


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)size {
    self = [super init];
    if (self) {
        _size = size;
        _values = malloc(sizeof(float) * size);
    }
    return self;
}


#pragma mark -
#pragma mark value


- (void)setValuesFromArray:(NSArray *)values {
    for (int i = 0; i < _size; i++) {
        _values[i] = [[values objectAtIndex:i] floatValue];
    }
}

- (void)setValue:(float)value atIndex:(int)i {
    if (i < _size && i >= 0) {
        _values[i] = value;
    }
}


#pragma mark -
#pragma mark time


- (void)setTimeTrack:(AHAnimationTimeTrack *)timeTrack {
    _timeTrack = timeTrack;
}

- (float)valueAtTime:(float)_time {
    float value = [_timeTrack indexAtTime:_time];
    
    int i = value;
    float percent = value - i;
    
    //dlog(@"val %F i %i percent %F", value, i, percent);
    
    // handle whole numbers
    if ((float) i == value) {
        return _values[i];
    }
    
    // handle under max
    if (i < _size) {
        return [AHMathUtils percent:percent betweenFloatA:_values[i] andFloatB:_values[i + 1]];
    } else {
        return [AHMathUtils percent:percent betweenFloatA:_values[i] andFloatB:_values[0]];
    }
}


@end
