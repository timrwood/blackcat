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


@class AHPhysicsBody;


#pragma mark -
#pragma mark contact protocol


@protocol AHContactDelegate <NSObject>


- (BOOL)collidedWith:(AHPhysicsBody *)contact;
- (BOOL)collidedWithButDidNotCall:(AHPhysicsBody *)contact;
- (BOOL)uncollidedWith:(AHPhysicsBody *)contact;
- (BOOL)uncollidedWithButDidNotCall:(AHPhysicsBody *)contact;


@end


#pragma mark -
#pragma mark body


@interface AHPhysicsBody : NSObject <AHActorComponent, AHContactDelegate> {
@private;
    NSObject <AHContactDelegate> *delegate;
    b2Body *_body;
}


#pragma mark -
#pragma mark vars


- (CGPoint)position;
- (float)rotation;


#pragma mark -
#pragma mark body


- (void)addBodyToWorld:(const b2BodyDef *)bodyDef;
- (void)addFixtureToBody:(const b2FixtureDef *)fixtureDef;
- (void)setStatic:(BOOL)isStatic;


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHContactDelegate> *)newDelegate;


@end
