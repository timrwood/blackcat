//
//  AHActorManager.h
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


@interface AHActorManager : NSObject <AHSubsystem> {
@private
    NSMutableArray *actors;
    NSMutableArray *actorsToAdd;
    NSMutableArray *actorsToDestroy;
}


#pragma mark -
#pragma mark singleton


+ (AHActorManager *)manager;


#pragma mark -
#pragma mark setup


- (void)setup;


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics;
- (void)updateBeforeAnimation;
- (void)updateBeforeRender;
- (void)updateAfterEverything;


#pragma mark -
#pragma mark teardown


- (void)teardown;


#pragma mark -
#pragma mark actors


- (void)add:(AHActor *)actor;
- (void)destroy:(AHActor *)actor;
- (void)destroyAll;


@end