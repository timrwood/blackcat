//
//  BCMaster.m
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


#import "BCMaster.h"


@interface BCMaster ()


- (void)reallyAdd:(BCActor *)actor;
- (void)reallyDestroy:(BCActor *)actor;


@end


@implementation BCMaster


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

- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark create


- (void)create {

}


#pragma mark -
#pragma mark update


- (void)update {
    [[BCInput manager] update];

    for (BCActor *actor in actors) {
        [actor updateBeforePhysics];
    }

    [[BCPhysics manager] update];

    for (BCActor *actor in actors) {
        [actor updateBeforeAnimation];
    }

    [[BCAnimation manager] update];

    for (BCActor *actor in actors) {
        [actor updateBeforeRender];
    }

    [[BCGraphics manager] draw];
    [[BCParticles manager] draw];

    for (BCActor *actor in actorsToDestroy) {
        [self reallyDestroy:actor];
    }

    for (BCActor *actor in actorsToAdd) {
        [self reallyAdd:actor];
    }
}


#pragma mark -
#pragma mark destroy


- (void)destroy {
    [self destroyAll];
}


#pragma mark -
#pragma mark actors add


- (void)add:(BCActor *)actor {
    if (![actorsToAdd containsObject:actor]) {
        [actorsToAdd addObject:actor];
    }
}

- (void)reallyAdd:(BCActor *)actor {
    if (![actors containsObject:actor]) {
        [actors addObject:actor];
    }
    if ([actorsToAdd containsObject:actor]) {
        [actorsToAdd removeObject:actor];
    }
}


#pragma mark -
#pragma mark actors remove


- (void)remove:(BCActor *)actor {
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


- (void)reallyDestroy:(BCActor *)actor {
    [actor cleanupBeforeDestruction];
    [actor destroy];
    [self remove:actor];
}

- (void)destroy:(BCActor *)actor  {
    if (![actorsToDestroy containsObject:actor]){
        [actorsToDestroy addObject:actor];
    }
}

- (void)destroyAll  {
    while ([actors count] > 0) {
        [self reallyDestroy:(BCActor *) [actors objectAtIndex:0]];
    }
}


@end