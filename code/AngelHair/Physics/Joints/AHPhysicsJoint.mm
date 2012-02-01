//
//  AHPhysicsJoint.m
//  BlackCat
//
//  Created by Tim Wood on 1/26/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHPhysicsBody.h"
#import "AHPhysicsJoint.h"


@implementation AHPhysicsJoint


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark joint


- (void)addJointToWorld:(const b2JointDef *)jointDef {
    _joint = [[AHPhysicsManager cppManager] world]->CreateJoint(jointDef);
}


#pragma mark -
#pragma mark bodies


- (void)setBodyA:(AHPhysicsBody *)bodyA
        andBodyB:(AHPhysicsBody *)bodyB {
    _bodyA = bodyA;
    _bodyB = bodyB;
    [_bodyA addJoint:self];
    [_bodyB addJoint:self];
}

- (void)removeSelfFromBodies {
    [_bodyA removeJoint:self];
    [_bodyB removeJoint:self];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    [self removeSelfFromBodies];
}


@end
