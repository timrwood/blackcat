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

- (void)setValueFromDictionary:(NSDictionary *)dict atIndex:(int)i {
    AHSkeleton skeleton;
    skeleton.x = [[dict objectForKey:@"x"] floatValue];
    skeleton.y = [[dict objectForKey:@"y"] floatValue];
    
    skeleton.neck = [[dict objectForKey:@"neck"] floatValue];
    
    skeleton.shoulderA = [[dict objectForKey:@"shoulderA"] floatValue];
    skeleton.shoulderB = [[dict objectForKey:@"shoulderB"] floatValue];
    
    skeleton.elbowA = [[dict objectForKey:@"elbowA"] floatValue];
    skeleton.elbowB = [[dict objectForKey:@"elbowB"] floatValue];
    
    skeleton.waist = [[dict objectForKey:@"waist"] floatValue];
    
    skeleton.kneeA = [[dict objectForKey:@"kneeA"] floatValue];
    skeleton.kneeB = [[dict objectForKey:@"kneeB"] floatValue];
    
    skeleton.hipA = [[dict objectForKey:@"hipA"] floatValue];
    skeleton.hipB = [[dict objectForKey:@"hipB"] floatValue];
    
    [self setValue:skeleton atIndex:i];
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
    
    return AHSkeletonAtPercentToSkeleton(_values[a], _values[b], percent);
}


@end

