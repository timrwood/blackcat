//
//  AHActor.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"
#import "AHActorMessage.h"


@interface AHActor : NSObject {
@private
    NSMutableArray *components;
}


#pragma mark -
#pragma mark components


- (void)addComponent:(AHActorComponent *)component;
- (void)removeComponent:(AHActorComponent *)component;
- (void)removeAllComponents;


#pragma mark -
#pragma mark setup


- (void)setup;


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics;
- (void)updateBeforeAnimation;
- (void)updateBeforeRender;


#pragma mark -
#pragma mark destroy


- (void)cleanupBeforeDestruction;
- (void)safeDestroy;
- (void)destroy;


#pragma mark -
#pragma mark messages


- (void)recieveMessage:(AHActorMessage *)message;
- (void)sendMessage:(AHActorMessage *)message;


@end
