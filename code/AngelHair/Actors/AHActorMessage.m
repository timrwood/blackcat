//
//  AHActorMessage.m
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorMessage.h"


@implementation AHActorMessage


#pragma mark -
#pragma mark init


- (id)initWithType:(int)type {
    return [self initWithType:type andPoint:CGPointMake(0.0f, 0.0f)];
}

- (id)initWithType:(int)type andFloat:(float)newFloat {
    return [self initWithType:type andPoint:CGPointMake(newFloat, 0.0f)];
}

- (id)initWithType:(int)type andPoint:(CGPoint)point {
    self = [super init];
    if (self) {
        _a = point.x;
        _b = point.y;
        _type = type;
    }
    return self;
}


#pragma mark -
#pragma mark getters


- (int)type {
    return _type;
}

- (float)valueAsFloat {
    return _a;
}

- (CGPoint)valueAsPoint {
    return CGPointMake(_a, _b);
}


@end
