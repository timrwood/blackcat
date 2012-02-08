//
//  AHLogicState.h
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"


@protocol AHLogicDelegate <NSObject>


@optional


- (void)stateChangedFrom:(int)oldState;
- (void)stateChangedTo:(int)newState;
- (void)stateChangedFrom:(int)oldState to:(int)newState;


@end


@interface AHLogicState : AHActorComponent {
@private;
    int _currentState;
    NSObject <AHLogicDelegate> *_delegate;
}


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHLogicDelegate> *)delegate;


#pragma mark -
#pragma mark states


- (void)changeState:(int)newState;
- (BOOL)isState:(int)state;
- (int)state;


@end
