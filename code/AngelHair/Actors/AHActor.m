//
//  AHActor.m
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"


@implementation AHActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        components = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark components


- (void)addComponent:(NSObject <AHActorComponent> *)component {
    if (![components containsObject:component]) {
        [components addObject:component];
    }
}

- (void)removeComponent:(NSObject <AHActorComponent> *)component {
    if ([components containsObject:component]) {
        [components removeObject:component];
    }
    [component cleanupAfterRemoval];
}

- (void)removeAllComponents {
    while ([components count] > 0) {
        [self removeComponent:(NSObject <AHActorComponent> *) [components objectAtIndex:0]];
    }
}


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    
}

- (void)updateBeforeAnimation {
    
}

- (void)updateBeforeRender {
    
}


#pragma mark -
#pragma mark destroy


- (void)cleanupBeforeDestruction {
    [self removeAllComponents];
}

- (void)destroy {
    
}


@end
