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
    return [self initWithType:type andPoint:GLKVector2Make(0.0f, 0.0f)];
}

- (id)initWithType:(int)type andFloat:(float)newFloat {
    return [self initWithType:type andPoint:GLKVector2Make(newFloat, 0.0f)];
}

- (id)initWithType:(int)type andPoint:(GLKVector2)point {
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

- (GLKVector2)valueAsPoint {
    return GLKVector2Make(_a, _b);
}


@end
