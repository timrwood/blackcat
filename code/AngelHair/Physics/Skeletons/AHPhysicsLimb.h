//
//  AHPhysicsLimb.h
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActorComponent.h"


@class AHPhysicsRect;
@class AHPhysicsRevoluteJoint;


@interface AHPhysicsLimb : AHActorComponent {
@private;
    GLKVector2 _position;
    float _length;
    float _width;
    float _angle;
    float _rotation;
    
    AHPhysicsBody *_bodyOrigin;
    AHPhysicsRect *_bodyA;
    AHPhysicsRect *_bodyB;
    AHPhysicsRevoluteJoint *_jointA;
    AHPhysicsRevoluteJoint *_jointB;
}


#pragma mark -
#pragma mark sizes


- (void)setLimitAUpper:(float)upper lower:(float)lower;
- (void)setLimitBUpper:(float)upper lower:(float)lower;
- (void)attachToBody:(AHPhysicsBody *)body;
- (void)setRotation:(float)rotation;
- (void)setPosition:(GLKVector2)position;
- (void)setWidth:(float)width;
- (void)setLength:(float)length;
- (void)setAngle:(float)angle;


#pragma mark -
#pragma mark angles


- (float)rotationA;
- (float)rotationB;


#pragma mark -
#pragma mark group


- (void)setGroup:(int16)group;


#pragma mark -
#pragma mark velocity


- (void)setLinearVelocity:(GLKVector2)velocity;


@end
