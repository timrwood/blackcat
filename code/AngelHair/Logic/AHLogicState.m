//
//  AHLogicState.m
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHLogicState.h"


@implementation AHLogicState


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHLogicDelegate> *)delegate {
    _delegate = delegate;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    _delegate = nil;
    [super cleanupAfterRemoval];
}


#pragma mark -
#pragma mark states


- (void)changeState:(int)newState {
    if (newState != _currentState) {
        if (_delegate && [_delegate respondsToSelector:@selector(stateChangedFrom:)]) {
            [_delegate stateChangedFrom:_currentState];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(stateChangedFrom:to:)]) {
            [_delegate stateChangedFrom:_currentState to:newState];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(stateChangedTo:)]) {
            [_delegate stateChangedTo:newState];
        }
        _currentState = newState;
    }
}

- (BOOL)isState:(int)state {
    return (state == _currentState);
}

- (int)state {
    return _currentState;
}


@end
