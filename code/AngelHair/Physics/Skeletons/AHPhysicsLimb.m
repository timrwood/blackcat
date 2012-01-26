//
//  AHPhysicsLimb.m
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"
#import "AHPhysicsRect.h"
#import "AHPhysicsRevoluteJoint.h"
#import "AHMathUtils.h"
#import "AHPhysicsLimb.h"


@implementation AHPhysicsLimb


#pragma mark -
#pragma mark init 


- (id)init {
    self = [super init];
    if (self) {
        _bodyA = [[AHPhysicsRect alloc] init];
        _bodyB = [[AHPhysicsRect alloc] init];
        _jointA = [[AHPhysicsRevoluteJoint alloc] init];
        _jointB = [[AHPhysicsRevoluteJoint alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark sizes


- (void)setLimitAUpper:(float)upper lower:(float)lower {
    [_jointA setLowerLimit:lower];
    [_jointA setUpperLimit:upper];
}

- (void)setLimitBUpper:(float)upper lower:(float)lower {
    [_jointB setLowerLimit:lower];
    [_jointB setUpperLimit:upper];
}

- (void)attachToBody:(AHPhysicsBody *)body {
    _bodyOrigin = body;
}

- (void)setRotation:(float)rotation {
    _rotation = rotation;
}

- (void)setPosition:(GLKVector2)position {
    _position = position;
}

- (void)setWidth:(float)width {
    _width = width;
}

- (void)setLength:(float)length {
    _length = length;
}

- (void)setAngle:(float)angle {
    _angle = angle;
}


#pragma mark -
#pragma mark setup


- (void)setActor:(AHActor *)actor {
    [super setActor:actor];
    [actor addComponent:_bodyA];
    [actor addComponent:_bodyB];
    [actor addComponent:_jointA];
    [actor addComponent:_jointB];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    GLKVector2 rotationNormalized = GLKVector2Make(cosf(_rotation), sinf(_rotation));
    GLKVector2 rotationPlusAngleNormalized = GLKVector2Make(cosf(_rotation + _angle), sinf(_rotation + _angle));
    
    GLKVector2 jointOriginAPoint = GLKVector2Subtract(_position, GLKVector2MultiplyScalar(rotationNormalized, _width / 2.0f));
    
    GLKVector2 jointABPoint = GLKVector2Add(jointOriginAPoint, GLKVector2MultiplyScalar(rotationNormalized, _length / 2.0f));
    GLKVector2 bodyACenterPoint = GLKVector2Add(jointOriginAPoint, GLKVector2MultiplyScalar(rotationNormalized, _length / 4.0f));
    
    GLKVector2 bodyBCenterPoint = GLKVector2Add(elbowPoint, GLKVector2MultiplyScalar(rotationPlusAngleNormalized, _length / 4.0f));
    
    CGSize size = CGSizeMake(_width / 2.0f, _height / 4.0f);
    
    [_bodyA setSize:size andRotation:_rotation andPosition:bodyACenterPoint];
    [_bodyB setSize:size andRotation:_rotation + _angle andPosition:bodyBCenterPoint];
    
    [_jointA joinBodyA:_bodyOrigin toBodyB:_bodyA atPosition:jointOriginAPoint];
    [_jointB joinBodyA:_bodyA toBodyB:_bodyB atPosition:jointABPoint];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    _bodyA = nil;
    _bodyB = nil;
    _bodyOrigin = nil;
    _jointA = nil;
    _jointB = nil;
}


@end



