//
//  BCPhysics.h
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


@interface BCPhysics : NSObject <BCSubsystem> {
@private
    b2World *world;
    BCContactListener *contactListener;
}


#pragma mark -
#pragma mark singleton


+ (BCPhysics *)manager;


#pragma mark -
#pragma mark setup


- (void)setup;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark teardown


- (void)teardown;


#pragma mark -
#pragma mark bodies


- (BCPhysicsCircle *)createCircleWithRadius:(float)radius;
- (BCPhysicsSquare *)createSquareWithSize:(b2Vec2)size;


@end