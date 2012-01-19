//
//  AHAnimationSkeletonTrack.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHAnimationSkeletonTrack.h"


@implementation AHAnimationSkeletonTrack


#pragma mark -
#pragma mark init


- (id)initWithSize:(int)newSize {
    self = [super initWithSize:newSize];
    if (self) {
        _values = malloc(sizeof(AHSkeleton) * newSize);
    }
    return self;
}


#pragma mark -
#pragma mark value


- (void)setValue:(AHSkeleton)value atIndex:(int)i {
    if (i < self->size && i >= 0) {
        _values[i] = value;
    }
}


#pragma mark -
#pragma mark time


- (AHSkeleton)valueAtTime:(float)_time {
    float percent = [self percentAtTime:_time];
    int a = [self indexAAtTime:_time];
    int b = [self indexBAtTime:_time];
    if (percent == 0.0f) {
        return _values[a];
    }
    dlog(@"percent %F   a %i   b %i   size %i", percent, a, b, self->size);
    return AHSkeletonAtPercentToSkeleton(_values[a], _values[b], percent);
}


@end

