//
//  AHPhysicsJoint.h
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActorComponent.h"
#import "AHPhysicsManager.h"
#import "AHPhysicsManagerCPP.h"


@class AHPhysicsBody;


@interface AHPhysicsJoint : AHActorComponent {
@protected;
    AHPhysicsBody *_bodyA;
    AHPhysicsBody *_bodyB;
    b2Joint *_joint;
}


#pragma mark -
#pragma mark joint


- (void)addJointToWorld:(const b2JointDef *)jointDef;


#pragma mark -
#pragma mark bodies


- (void)setBodyA:(AHPhysicsBody *)bodyA
        andBodyB:(AHPhysicsBody *)bodyB;


@end
