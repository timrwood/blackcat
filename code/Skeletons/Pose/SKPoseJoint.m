//
//  SKPoseJoint.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHMathUtils.h"
#import "SKPoseJoint.h"


@implementation SKPoseJoint


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark properties


@synthesize position = _position;
@synthesize length;
@synthesize parent;

- (GLKVector2)position {
    if (parent) {
        return GLKVector2Add([self rotatePoint:_position radians:[parent rotation]], [parent position]);
    }
    return _position;
}


#pragma mark -
#pragma mark rotation


- (GLKVector2)rotatePoint:(GLKVector2)point
                  radians:(float)radians {
    GLKMatrix3 rotationMatrix = GLKMatrix3MakeZRotation(radians);
    GLKVector3 v3 = GLKVector3Make(point.x, point.y, 0.0f);
    v3 = GLKMatrix3MultiplyVector3(rotationMatrix, v3);
    return GLKVector2Make(v3.x, v3.y);
}

- (void)setRotation:(float)rotation {
    if (rotation > 0.0f) {
        _rotation = fmodf(rotation + M_TAU_2, M_TAU) - M_TAU_2;
    } else {
        _rotation = fmodf(rotation - M_TAU_2, M_TAU) + M_TAU_2;
    }
}

- (float)selfRotation {
    return _rotation;
}

- (float)rotation {
    if (parent) {
        return [parent rotation] + _rotation;
    }
    return _rotation;
}


#pragma mark -
#pragma mark position


- (void)updatePosition {
    _originPoint = [self position];
    _endPoint = GLKVector2Add(_originPoint, [self rotatePoint:length radians:[self rotation]]);
}

- (GLKVector2)endPoint {
    return _endPoint;
}

- (void)rotateTowardsPoint:(GLKVector2)point {
    GLKVector2 diff = GLKVector2Subtract(point, [self position]);
    float angle = atan2f(diff.y, diff.x);
    float angle2 = atan2f(length.y, length.x);
    [self setRotation:angle - angle2 - [parent rotation]];
}


#pragma mark -
#pragma mark draw


- (void)drawInContext:(CGContextRef)c {
    [self updatePosition];
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, _originPoint.x, _originPoint.y);
    CGContextAddLineToPoint(c, _endPoint.x, _endPoint.y);
    CGContextStrokePath(c);
}


@end






