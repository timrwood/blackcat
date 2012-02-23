//
//  BCHeroJumpController.mm
//  BlackCat
//
//  Created by Tim Wood on 2/23/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define MAX_SAFETY_RANGE_FRAMES 3

#define JUMP_HEIGHT 3.5f
#define JUMP_HEIGHT_MULTIPLIER 30.0f
#define JUMP_HOVER_TIME 0.1f

#define JUMP_MIN_DISTANCE 0.1f

#define JUMP_UPWARD_SLOWING 1.35f
#define JUMP_DOWNWARD_SLOWING 1.4f
#define JUMP_MAX_DOWNWARD_SLOWING 10.0f

#define STATE_CAN_JUMP 0
#define STATE_IS_JUMPING 1
#define STATE_IS_FALLING 2
#define STATE_CANNOT_JUMP 3

#define INITIAL_RUN_SPEED 20.0f


#import "AHTimeManager.h"
#import "AHPhysicsManager.h"
#import "AHPhysicsManagerCPP.h"
#import "AHPhysicsBody.h"

#import "BCGlobalTypes.h"
#import "BCHeroActor.h"
#import "BCHeroJumpController.h"


@implementation BCHeroJumpController


#pragma mark -
#pragma mark init


- (id)initWithHero:(BCHeroActor *)hero {
    self = [super init];
    if (self) {
        _hero = hero;
        
        // jumping state
        _jumpingState = [[AHLogicState alloc] init];
        [_jumpingState setDelegate:self];
        [_hero addComponent:_jumpingState];
        
        // vertical speeds
        _upwardSlowing = powf(JUMP_UPWARD_SLOWING, 60.0f / [[AHTimeManager manager] realFramesPerSecond]);
        _downwardSlowing = powf(JUMP_DOWNWARD_SLOWING, 60.0f / [[AHTimeManager manager] realFramesPerSecond]);
        
        // horizontal speeds
        _runSpeed = INITIAL_RUN_SPEED;
        _speedIncrease = 0.01f * [[AHTimeManager manager] realFramesPerSecond] / 60.0f;
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    
}

- (void)updateBeforeAnimation {
    // if jumping and velocity is greater than 0, then change to falling
    //if ([_jumpingState state] == STATE_IS_JUMPING && [[_hero body] linearVelocity].y > 0.0f) {
    //    [_jumpingState changeState:STATE_IS_FALLING];
    //}
}

- (void)updateBeforeRender {
    if ([_jumpingState state] == STATE_IS_JUMPING) {
        [self updateHittingHead];
    } else {
        [self updateJumpability];
    }
}

- (void)updateJumpability {
    GLKVector2 pos = [[_hero body] position];
    GLKVector2 foot = pos;
    foot.y += HERO_HEIGHT * HERO_HEIGHT_RAYCAST_RADIUS_RATIO;
    
    int cat = [[AHPhysicsManager cppManager] getFirstActorCategoryWithTag:PHY_TAG_JUMPABLE from:pos to:foot];
    
    if (cat != PHY_CAT_NONE) {
        [_jumpingState changeState:STATE_CAN_JUMP];
        _safetyRange = MAX_SAFETY_RANGE_FRAMES;
    } else if ([_jumpingState state] == STATE_CAN_JUMP) {
        if (_safetyRange > 0) {
            _safetyRange--;
        } else {
            [_jumpingState changeState:STATE_CANNOT_JUMP];
        }
    }
}

- (void)updateHittingHead {
    GLKVector2 pos = [[_hero body] position];
    GLKVector2 head = pos;
    head.y -= HERO_HEIGHT * HERO_HEIGHT_RAYCAST_RADIUS_RATIO;
    
    int cat = [[AHPhysicsManager cppManager] getFirstActorCategoryWithTag:PHY_TAG_JUMPABLE from:pos to:head];
    
    if (cat != PHY_CAT_NONE) {
        [_jumpingState changeState:STATE_IS_FALLING];
    }
}


#pragma mark -
#pragma mark state


- (void)stateChangedTo:(int)newState {
    switch (newState) {
        case STATE_IS_JUMPING:
            _hoverTime = JUMP_HOVER_TIME;
            _targetHeight = [[_hero body] position].y - JUMP_HEIGHT;
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark velocity


- (GLKVector2)modifyVelocity:(GLKVector2)velocity {
    //GLKVector2 velocity = [_body linearVelocity];
    
    // increase velocity
    //if (_runSpeed < 15.0f) {
        //_runSpeed += _speedIncrease;
    //} else if (_runSpeed < 50.0f) {
        //_runSpeed += _speedIncrease / 2.0f;
    //}
    velocity.x = _runSpeed;
    
    float yDiff = _targetHeight - [[_hero body] position].y ;
    
    if ([_jumpingState state] == STATE_IS_JUMPING) {
        if (fabsf(yDiff) < JUMP_MIN_DISTANCE) {
            if (_hoverTime < 0.0f) {
                [_jumpingState changeState:STATE_IS_FALLING];
            } else {
                velocity.y = yDiff * [[AHTimeManager manager] worldFramesPerSecond];
                _hoverTime -= [[AHTimeManager manager] worldSecondsPerFrame];
            }
        } else {
            velocity.y = yDiff * JUMP_HEIGHT_MULTIPLIER;
        }
    } else {
        // make jumping snappier
        if (velocity.y > 0.0f && velocity.y < JUMP_MAX_DOWNWARD_SLOWING) {
            velocity.y *= _downwardSlowing;
        } else if (velocity.y < 0.0f) {
            velocity.y /= _upwardSlowing;
        }
    }
    
    // change to falling
    
    // set vars
    return velocity;
}


#pragma mark -
#pragma mark jump


- (void)jump {
    if ([_jumpingState isState:STATE_CAN_JUMP]) {
        [_jumpingState changeState:STATE_IS_JUMPING];
    }
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    _hero = nil;
    _jumpingState = nil;
    [super cleanupAfterRemoval];
}


@end
