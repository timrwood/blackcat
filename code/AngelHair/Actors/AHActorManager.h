//
//  AHActorManager.h
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


#import "AHSubSystem.h"


@class AHActor;
@class AHActorMessage;


@interface AHActorManager : NSObject <AHSubSystem> {
@private
    NSMutableArray *actors;
    NSMutableArray *actorsToAdd;
    NSMutableArray *actorsToDestroy;
    NSMutableArray *messages;
}


#pragma mark -
#pragma mark singleton


+ (AHActorManager *)manager;


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics;
- (void)updateBeforeAnimation;
- (void)updateBeforeRender;
- (void)updateAfterEverything;


#pragma mark -
#pragma mark actors


- (void)add:(AHActor *)actor;
- (void)destroy:(AHActor *)actor;
- (void)destroyAll;


#pragma mark -
#pragma mark messages


- (void)sendMessage:(AHActorMessage *)message;


@end