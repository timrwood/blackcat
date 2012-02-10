//
//  AHActorMessage.m
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActorMessage.h"


@implementation AHActorMessage


#pragma mark -
#pragma mark init


- (id)initWithType:(int)type {
    float floats[4];
    return [self initWithType:type and4Floats:floats];
}

- (id)initWithType:(int)type andFloat:(float)newFloat {
    float floats[4];
    floats[0] = newFloat;
    return [self initWithType:type and4Floats:floats];
}

- (id)initWithType:(int)type andFloat:(float)newFloat andFloat:(float)newFloat2 {
    float floats[4];
    floats[0] = newFloat;
    floats[1] = newFloat2;
    return [self initWithType:type and4Floats:floats];
}

- (id)initWithType:(int)type andPoint:(GLKVector2)point {
    float floats[4];
    floats[0] = point.x;
    floats[1] = point.y;
    return [self initWithType:type and4Floats:floats];
}

- (id)initWithType:(int)type andPoint:(GLKVector2)point andFloat:(float)newFloat2 {
    float floats[4];
    floats[0] = point.x;
    floats[1] = point.y;
    floats[2] = newFloat2;
    return [self initWithType:type and4Floats:floats];
}

- (id)initWithType:(int)type andPoint:(GLKVector2)point andPoint:(GLKVector2)point2 {
    float floats[4];
    floats[0] = point.x;
    floats[1] = point.y;
    floats[2] = point2.x;
    floats[3] = point2.y;
    return [self initWithType:type and4Floats:floats];
}

- (id)initWithType:(int)type and4Floats:(float *)floats {
    self = [super init];
    if (self) {
        _a = floats[0];
        _b = floats[1];
        _c = floats[2];
        _d = floats[3];
        _type = type;
    }
    return self;
}


#pragma mark -
#pragma mark getters


- (int)type {
    return _type;
}

- (float)firstFloat {
    return _a;
}

- (float)secondFloat {
    return _b;
}

- (float)thirdFloat {
    return _c;
}

- (float)fourthFloat {
    return _d;
}

- (GLKVector2)firstPoint {
    return GLKVector2Make(_a, _b);
}

- (GLKVector2)secondPoint {
    return GLKVector2Make(_c, _d);
}


@end
