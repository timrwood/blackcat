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
        
        // debug
        //[_bodyA setStatic:YES];
        //[_bodyB setStatic:YES];
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
    float originToCenterA = _length / 4.0f - _width / 2.0f;
    float originToJointB = _length / 2.0f - _width;
    float jointBToCenterB = _length / 4.0f - _width / 2.0f;
    float angleB = _rotation + _angle;
    
    GLKVector2 rotationNormalized = GLKVector2Make(-sinf(_rotation), cosf(_rotation));
    GLKVector2 angleNormalized = GLKVector2Make(-sinf(angleB), cosf(angleB));
    
    GLKVector2 jointBPoint = GLKVector2Add(_position, GLKVector2MultiplyScalar(rotationNormalized, originToJointB));
    
    GLKVector2 bodyACenterPoint = GLKVector2Add(_position, GLKVector2MultiplyScalar(rotationNormalized, originToCenterA));
    GLKVector2 bodyBCenterPoint = GLKVector2Add(jointBPoint, GLKVector2MultiplyScalar(angleNormalized, jointBToCenterB));
    
    CGSize size = CGSizeMake(_width / 2.0f, _length / 4.0f);
    
    [_bodyA setSize:size andRotation:_rotation andPosition:bodyACenterPoint];
    [_bodyB setSize:size andRotation:angleB andPosition:bodyBCenterPoint];
    
    [_jointA joinBodyA:_bodyOrigin toBodyB:_bodyA atPosition:_position];
    [_jointB joinBodyA:_bodyA toBodyB:_bodyB atPosition:jointBPoint];
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


#pragma mark -
#pragma mark angles


- (float)rotationA {
    if (_bodyA) {
        return [_bodyA rotation];
    }
    return 0.0f;
}

- (float)rotationB {
    if (_bodyB && _bodyA) {
        return [_bodyB rotation] - [_bodyA rotation];
    }
    return 0.0f;
}



#pragma mark -
#pragma mark group


- (void)setGroup:(int16)group {
    [_bodyA setGroup:group];
    [_bodyB setGroup:group];
}


#pragma mark -
#pragma mark velocity


- (void)setLinearVelocity:(GLKVector2)velocity {
    [_bodyA setLinearVelocity:velocity];
    [_bodyB setLinearVelocity:velocity];
}


@end



