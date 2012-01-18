//
//  AHContactDelegate.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


@class AHPhysicsBody;


#pragma mark -
#pragma mark contact protocol


@protocol AHContactDelegate <NSObject>


@optional;


- (BOOL)willCollideWith:(AHPhysicsBody *)contact;
- (BOOL)willCollideWithButWillNotCall:(AHPhysicsBody *)contact;
- (BOOL)collidedWith:(AHPhysicsBody *)contact;
- (BOOL)collidedWithButDidNotCall:(AHPhysicsBody *)contact;
- (BOOL)uncollidedWith:(AHPhysicsBody *)contact;
- (BOOL)uncollidedWithButDidNotCall:(AHPhysicsBody *)contact;


@end
