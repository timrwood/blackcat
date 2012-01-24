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


- (id)initWithSize:(int)newSize {
    self = [super initWithSize:newSize];
    if (self) {
        _values = malloc(sizeof(float) * newSize);
    }
    return self;
}


#pragma mark -
#pragma mark value


- (void)setValuesFromArray:(NSArray *)values {
    for (int i = 0; i < self->size; i++) {
        _values[i] = [[values objectAtIndex:i] floatValue];
    }
}

- (void)setValue:(float)value atIndex:(int)i {
    if (i < self->size && i >= 0) {
        _values[i] = value;
    }
}


#pragma mark -
#pragma mark time


- (float)valueAtTime:(float)_time {
    float percent = [self percentAtTime:_time];
    int a = [self indexAAtTime:_time];
    int b = [self indexBAtTime:_time];
    if (percent == 0.0f) {
        return _values[a];
    }
    return FloatLerp(_values[a], _values[b], percent);
}


@end
