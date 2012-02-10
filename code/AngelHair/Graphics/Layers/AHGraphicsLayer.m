//
//  AHGraphicsLayer.m
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHTextureManager.h"
#import "AHGraphicsManager.h"
#import "AHGraphicsObject.h"
#import "AHGraphicsLayer.h"


@implementation AHGraphicsLayer


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _objects = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark objects


- (BOOL)hasObjects {
    if ([_objects count] > 0) {
        return YES;
    }
    return NO;
}

- (void)addObject:(AHGraphicsObject *)object {
    if (![_objects containsObject:object]) {
        [_objects addObject:object];
        [object setLayer:self];
    }
}

- (void)removeObject:(AHGraphicsObject *)object {
    if ([_objects containsObject:object]) {
        [_objects removeObject:object];
        [object setLayer:nil];
    }
}

- (void)removeAllObjects {
    while ([_objects count] > 0) {
        [self removeObject:(AHGraphicsObject *)[_objects objectAtIndex:0]];
    }
}


#pragma mark -
#pragma mark draw


- (void)draw {
    for (AHGraphicsObject *object in _objects) {
        [[AHTextureManager manager] activateBaseTexture:[object texture]];
        if ([object normalTexture]) {
            [[AHGraphicsManager manager] enableNormal:YES];
            [[AHTextureManager manager] activateNormalTexture:[object normalTexture]];
        } else {
            [[AHGraphicsManager manager] enableNormal:NO];
        }
        [object draw];
    }
}


#pragma mark -
#pragma mark update


- (void)update {
    for (AHGraphicsObject *object in _objects) {
        [object update];
    }
}


@end
