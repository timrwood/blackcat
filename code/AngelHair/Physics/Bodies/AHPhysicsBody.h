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


@class AHPhysicsJoint;


#pragma mark -
#pragma mark body


@interface AHPhysicsBody : AHActorComponent <AHContactDelegate> {
@protected;
    float restitution;
    float friction;
    BOOL _isSensor;
    int16 group;
@private;
    NSMutableArray *_joints;
    NSObject <AHContactDelegate> *delegate;
    b2Body *_body;
    b2BodyType _bodyType;
    int _tags;
    int _category;
    b2Vec2 _velocity;
}


#pragma mark -
#pragma mark joints


- (void)addJoint:(AHPhysicsJoint *)joint;
- (void)removeJoint:(AHPhysicsJoint *)joint;
- (void)removeAllJoints;


#pragma mark -
#pragma mark setup


- (void)setFriction:(float)newFriction;
- (void)setRestitution:(float)newRestitution;


#pragma mark -
#pragma mark position + rotation


- (GLKVector2)position;
- (void)setPosition:(GLKVector2)newPosition;
- (float)rotation;
- (void)setRotation:(float)rotation;


#pragma mark -
#pragma mark velocity


- (GLKVector2)force;
- (GLKVector2)linearVelocity;
- (float)angularVelocity;
- (void)setLinearVelocity:(GLKVector2)vel;
- (void)setLinearVelocity:(GLKVector2)vel atWorldPoint:(GLKVector2)point;
- (void)setAngularVelocity:(float)vel;


#pragma mark -
#pragma mark body


- (b2Body *)body;
- (void)addBodyToWorld:(const b2BodyDef *)bodyDef;
- (void)addFixtureToBody:(const b2FixtureDef *)fixtureDef;
- (void)setStatic:(BOOL)isStatic;
- (void)setSensor:(BOOL)isSensor;


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHContactDelegate> *)newDelegate;


#pragma mark -
#pragma mark tags


- (void)addTag:(int)tag;
- (void)removeTag:(int)tag;
- (BOOL)hasTag:(int)tag;


#pragma mark -
#pragma mark category


- (void)setCategory:(int)category;
- (int)category;


#pragma mark -
#pragma mark group


- (void)setGroup:(int16)_group;


@end
