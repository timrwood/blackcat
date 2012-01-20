//
//  AHGraphicsLayer.m
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


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
        if ([object textureName] != _currentTexture) {
            _currentTexture = [object textureName];
            glBindTexture(GL_TEXTURE0, _currentTexture);
        }
        [object draw];
    }
}


@end
