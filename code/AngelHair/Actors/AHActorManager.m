//
//  AHActorManager.m
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


#import "AHActorManager.h"

// singleton
static AHActorManager *_manager = nil;


@interface AHActorManager ()


- (void)reallyAdd:(AHActor *)actor;
- (void)remove:(AHActor *)actor;
- (void)reallyDestroy:(AHActor *)actor;


@end


@implementation AHActorManager


#pragma mark -
#pragma mark singleton


+ (AHActorManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        actors = [[NSMutableArray alloc] init]];
        actorsToAdd = [[NSMutableArray alloc] init]];
        actorsToDestroy = [[NSMutableArray alloc] init]];
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {

}


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    for (AHActor *actor in actors) {
        [actor updateBeforePhysics];
    }
}

- (void)updateBeforeAnimation {
    for (AHActor *actor in actors) {
        [actor updateBeforeAnimation];
    }
}

- (void)updateBeforeRender {
    for (AHActor *actor in actors) {
        [actor updateBeforeRender];
    }
}

- (void)updateAfterEverything {
    for (AHActor *actor in actorsToDestroy) {
        [self reallyDestroy:actor];
    }
    
    for (AHActor *actor in actorsToAdd) {
        [self reallyAdd:actor];
    }
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    [self destroyAll];
}


#pragma mark -
#pragma mark actors add


- (void)add:(AHActor *)actor {
    if (![actorsToAdd containsObject:actor]) {
        [actorsToAdd addObject:actor];
    }
}

- (void)reallyAdd:(AHActor *)actor {
    if (![actors containsObject:actor]) {
        [actors addObject:actor];
    }
    if ([actorsToAdd containsObject:actor]) {
        [actorsToAdd removeObject:actor];
    }
}


#pragma mark -
#pragma mark actors remove


- (void)remove:(AHActor *)actor {
    if ([actorsToDestroy containsObject:actor]) {
        [actorsToDestroy removeObject:actor];
    }
    if ([actorsToAdd containsObject:actor]) {
        [actorsToAdd removeObject:actor];
    }
    if ([actors containsObject:actor]) {
        [actors removeObject:actor];
    }
}


#pragma mark -
#pragma mark actors remove


- (void)destroy:(AHActor *)actor  {
    if (![actorsToDestroy containsObject:actor]){
        [actorsToDestroy addObject:actor];
    }
}

- (void)reallyDestroy:(AHActor *)actor {
    [actor cleanupBeforeDestruction];
    [actor destroy];
    [self remove:actor];
}

- (void)destroyAll  {
    while ([actors count] > 0) {
        [self reallyDestroy:(BCActor *) [actors objectAtIndex:0]];
    }
}


@end