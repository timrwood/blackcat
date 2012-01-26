//
//  AHPhysicsRevoluteJoint.h
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsJoint.h"


@class AHPhysicsBody;


@interface AHPhysicsRevoluteJoint : AHPhysicsJoint {
@private;
    b2Vec2 _position;
    
    BOOL _isAngleLimited;
    float _upperLimit;
    float _lowerLimit;
    
    BOOL _isMotorized;
    float _motorSpeed;
}


#pragma mark -
#pragma mark join


- (void)joinBodyA:(AHPhysicsBody *)bodyA
          toBodyB:(AHPhysicsBody *)bodyB
       atPosition:(GLKVector2)position;


#pragma mark -
#pragma mark rotation


- (float)rotation;


#pragma mark -
#pragma mark limits


- (void)setUpperLimit:(float)upperLimit;
- (void)setLowerLimit:(float)lowerLimit;


#pragma mark -
#pragma mark motor


- (void)setMotorSpeed:(float)motorSpeed;


@end
