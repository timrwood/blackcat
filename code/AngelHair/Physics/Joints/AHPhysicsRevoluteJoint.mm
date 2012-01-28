//
//  AHPhysicsRevoluteJoint.m
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsRevoluteJoint.h"
#import "AHPhysicsBody.h"


@implementation AHPhysicsRevoluteJoint


#pragma mark -
#pragma mark join


- (void)joinBodyA:(AHPhysicsBody *)bodyA
          toBodyB:(AHPhysicsBody *)bodyB
       atPosition:(GLKVector2)position {
    [self setBodyA:bodyA andBodyB:bodyB];
    _position = b2Vec2(position.x, position.y);
}


#pragma mark -
#pragma mark setup


- (void)setup {
    if (!self->_bodyA) {
        dlog(@"ERROR: Body not defined yet");
    }
    if (!self->_bodyB) {
        dlog(@"ERROR: Body not defined yet");
    }
    
    b2RevoluteJointDef revJointDef;
    revJointDef.Initialize([self->_bodyA body], [self->_bodyB body], _position);
    
    // angle limiting
    if (_isAngleLimited) {
        revJointDef.lowerAngle = _lowerLimit;
        revJointDef.upperAngle = _upperLimit;
        revJointDef.enableLimit = YES;
    }
    
    if (_isMotorized) {
        revJointDef.motorSpeed = _motorSpeed;
        revJointDef.enableMotor = YES;
    }
    
    revJointDef.referenceAngle = _rotation;
    
    [self addJointToWorld:&revJointDef];
}


#pragma mark -
#pragma mark rotation


- (void)setRotation:(float)rotation {
    _rotation = rotation;
}

- (float)rotation {
    if (self->_joint) {
        b2RevoluteJoint *joint = (b2RevoluteJoint *)self->_joint;
        return joint->GetJointAngle();
    }
    return 0.0f;
}


#pragma mark -
#pragma mark limits


- (void)setUpperLimit:(float)upperLimit {
    _isAngleLimited = YES;
    _upperLimit = upperLimit;
    if (self->_joint) {
        b2RevoluteJoint *joint = (b2RevoluteJoint *)self->_joint;
        joint->EnableLimit(YES);
        joint->SetLimits(_lowerLimit, _upperLimit);
    }
}

- (void)setLowerLimit:(float)lowerLimit {
    _isAngleLimited = YES;
    _lowerLimit = lowerLimit;
    if (self->_joint) {
        b2RevoluteJoint *joint = (b2RevoluteJoint *)self->_joint;
        joint->EnableLimit(YES);
        joint->SetLimits(_lowerLimit, _upperLimit);
    }
}


#pragma mark -
#pragma mark motor


- (void)setMotorSpeed:(float)motorSpeed {
    _isMotorized = YES;
    _motorSpeed = motorSpeed;
    if (self->_joint) {
        b2RevoluteJoint *joint = (b2RevoluteJoint *)self->_joint;
        joint->EnableMotor(YES);
        joint->SetMotorSpeed(_motorSpeed);
    }
}


@end
