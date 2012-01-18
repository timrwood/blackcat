//
//  BCHeroActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"
#import "AHInputComponent.h"
#import "AHContactDelegate.h"


@class AHPhysicsCircle;


@interface BCHeroActor : AHActor <AHInputDelegate> {
@private;
    AHPhysicsCircle *_body;
    AHInputComponent *_input;
    
    BOOL _canJump;
    BOOL _isJumping;
    
    float _runSpeed;
    int _safetyRange;
    
    float _upwardSlowing;
    float _downwardSlowing;
    
    float _speedIncrease;
}


#pragma mark -
#pragma mark update


- (void)updateVelocity;
- (void)updateJumpability;
- (void)updateCamera;


@end
