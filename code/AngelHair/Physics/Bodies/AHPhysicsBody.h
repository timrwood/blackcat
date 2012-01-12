//
//  AHPhysicsBody.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"
#import "AHPhysicsManager.h"
#import "AHPhysicsManagerCPP.h"
#import "AHContactDelegate.h"


#pragma mark -
#pragma mark body


@interface AHPhysicsBody : AHActorComponent <AHContactDelegate> {
@private;
    NSObject <AHContactDelegate> *delegate;
    b2Body *_body;
    b2BodyType _bodyType;
@protected;
    float restitution;
    float friction;
}


#pragma mark -
#pragma mark vars


- (void)setFriction:(float)newFriction;
- (void)setRestitution:(float)newRestitution;
- (CGPoint)position;
- (float)rotation;
- (CGPoint)linearVelocity;
- (float)angularVelocity;
- (void)setLinearVelocity:(CGPoint)vel;
- (void)setAngularVelocity:(float)vel;


#pragma mark -
#pragma mark body


- (void)addBodyToWorld:(const b2BodyDef *)bodyDef;
- (void)addFixtureToBody:(const b2FixtureDef *)fixtureDef;
- (void)setStatic:(BOOL)isStatic;


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHContactDelegate> *)newDelegate;


@end
