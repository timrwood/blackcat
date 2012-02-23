//
//  BCHeroJumpController.h
//  BlackCat
//
//  Created by Tim Wood on 2/23/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"


@class BCHeroActor;


@interface BCHeroJumpController : AHActorComponent <AHLogicDelegate> {
@private;
    BCHeroActor *_hero;
    
    AHLogicState *_jumpingState;
    
    int _safetyRange;
    
    float _upwardSlowing;
    float _downwardSlowing;
    
    float _hoverTime;
    
    float _runSpeed;
    float _speedIncrease;
    
    float _targetHeight;
}


#pragma mark -
#pragma mark init


- (id)initWithHero:(BCHeroActor *)hero;


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics;
- (void)updateBeforeAnimation;
- (void)updateBeforeRender;
- (void)updateJumpability;
- (void)updateHittingHead;


#pragma mark -
#pragma mark velocity


- (GLKVector2)modifyVelocity:(GLKVector2)velocity;


#pragma mark -
#pragma mark jump


- (void)jump;


@end
