//
//  AHInputManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHMathUtils.h"
#import "AHInputManager.h"
#import "AHInputComponent.h"


static AHInputManager *_manager = nil;


@implementation AHInputManager


#pragma mark -
#pragma mark singleton


+ (AHInputManager *)manager {
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
        _touchDict = [[NSMutableDictionary alloc] init];
        _components = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


#pragma mark -
#pragma mark inputs


- (void)addInputComponent:(AHInputComponent *)input {
    if (![_components containsObject:input]) {
        [_components addObject:input];
    }
}

- (void)removeInputComponent:(AHInputComponent *)input {
    if ([_components containsObject:input]) {
        [_components removeObject:input];
    }
}

- (void)removeAllInputComponents {
    while ([_components count] > 0) {
        [self removeInputComponent:(AHInputComponent *)[_components objectAtIndex:0]];
    }
}


#pragma mark -
#pragma mark touches


- (GLKVector2)pointForTouch:(UITouch *)touch {
    return CGPointToGLKVector2([touch locationInView:[touch view]]);
}

- (void)touchBegan:(UITouch *)touch {
    GLKVector2 point = [self pointForTouch:touch];
    NSValue *key = [NSValue valueWithPointer:(__bridge void *) touch];
    
    for (AHInputComponent *component in _components) {
        if ([component containsPoint:point]){
            [component touchBeganAtPoint:point];
            [_touchDict setObject:component forKey:key];
            break;
        }
    }
}

- (void)touchMoved:(UITouch *)touch {
    GLKVector2 point = [self pointForTouch:touch];
    NSValue *key = [NSValue valueWithPointer:(__bridge void *) touch];
    
    NSObject *obj = [_touchDict objectForKey:key];
    if ([obj isKindOfClass:[AHInputComponent class]]) {
        AHInputComponent *component = (AHInputComponent *)obj;
        [component touchMovedAtPoint:point];
    }
}

- (void)touchEnded:(UITouch *)touch {
    GLKVector2 point = [self pointForTouch:touch];
    NSValue *key = [NSValue valueWithPointer:(__bridge void *) touch];
    
    NSObject *obj = [_touchDict objectForKey:key];
    if ([obj isKindOfClass:[AHInputComponent class]]) {
        AHInputComponent *component = (AHInputComponent *)obj;
        [component touchEndedAtPoint:point];
    }
    [_touchDict removeObjectForKey:key];
}


@end
