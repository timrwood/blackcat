//
//  AHActorComponent.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActor.h"
#import "AHActorComponent.h"
#import "AHActorManager.h"


@implementation AHActorComponent


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark actor


- (void)setActor:(AHActor *)actor {
    _actor = actor;
}

- (void)destroyActor {
    if (_actor) {
        [[AHActorManager manager] destroy:_actor];
    }
}


#pragma mark -
#pragma mark destroy


- (void)cleanupAfterRemoval {
    _actor = nil;
}


@end
