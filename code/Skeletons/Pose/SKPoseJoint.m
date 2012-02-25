//
//  SKPoseJoint.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "SKPoseJoint.h"


@implementation SKPoseJoint


- (id)init
{
    self = [super init];
    if (self) {
        originPoint = GLKVector2Make(4.0f, 20.0f);
        endPoint = GLKVector2Make(50.0f, 50.0f);
    }
    return self;
}


#pragma mark -
#pragma mark properties


@synthesize position = _position;
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
    _rotation = rotation;
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
    originPoint = [self position];
    endPoint = GLKVector2Add(originPoint, [self rotatePoint:GLKVector2Make(0.0f, 50.0f) radians:[self rotation]]);
}


#pragma mark -
#pragma mark draw


- (void)drawInContext:(CGContextRef)c {
    [self updatePosition];
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, originPoint.x, originPoint.y);
    CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
    CGContextStrokePath(c);
}


@end
