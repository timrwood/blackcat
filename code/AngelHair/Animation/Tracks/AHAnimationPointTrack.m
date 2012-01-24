//
//  AHAnimationPointTrack.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHMathUtils.h"
#import "AHAnimationPointTrack.h"


@implementation AHAnimationPointTrack


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)newSize {
    self = [super initWithSize:newSize];
    if (self) {
        _values = malloc(sizeof(GLKVector2) * newSize);
    }
    return self;
}


#pragma mark -
#pragma mark value


- (void)setValuesFromArray:(NSArray *)values {
    for (int i = 0; i < self->size; i++) {
        _values[i] = CGPointToGLKVector2([[values objectAtIndex:i] CGPointValue]);
    }
}

- (void)setValue:(GLKVector2)value atIndex:(int)i {
    if (i < self->size && i >= 0) {
        _values[i] = value;
    }
}


#pragma mark -
#pragma mark time


- (GLKVector2)valueAtTime:(float)_time {
    float percent = [self percentAtTime:_time];
    int a = [self indexAAtTime:_time];
    int b = [self indexBAtTime:_time];
    if (percent == 0.0f) {
        return _values[a];
    }
    //dlog(@"percent %F   a %i   b %i   size %i", percent, a, b, self->size);
    return GLKVector2Lerp(_values[a], _values[b], percent);
}


@end
