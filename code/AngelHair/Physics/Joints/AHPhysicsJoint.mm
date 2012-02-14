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
    _joint->SetUserData((__bridge void *) self);
}


#pragma mark -
#pragma mark bodies


- (void)setBodyA:(AHPhysicsBody *)bodyA
        andBodyB:(AHPhysicsBody *)bodyB {
    _bodyA = bodyA;
    _bodyB = bodyB;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    
}


@end
