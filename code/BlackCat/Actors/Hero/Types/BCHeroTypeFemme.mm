//
//  BCHeroTypeFemme.mm
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define PHASEWALK_DISTANCE_TO_CANCEL 1.0f
#define PHASEWALK_VELOCITY 4.0f

#define PHASEWALK_MAX_TIME 0.5f
#define PHASEWALK_TIMEOUT 1.0f

#import "AHTimeManager.h"
#import "AHPhysicsBody.h"
#import "AHGraphicsManager.h"

#import "BCHeroActor.h"
#import "BCHeroTypeFemme.h"


typedef enum {
    STATE_IS_PHASEWALKING,
    STATE_CAN_PHASEWALK,
    STATE_CANNOT_PHASEWALK
} BCFemmePhasewalkState;


@implementation BCHeroTypeFemme


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _phasewalkState = [[AHLogicState alloc] init];
        [_phasewalkState changeState:STATE_CAN_PHASEWALK];
        [_phasewalkState setDelegate:self];
        
        _timeStartedPhasewalk = 0.0f;
    }
    return self;
}


#pragma mark -
#pragma mark skin


- (void)configSkeletonSkin:(AHGraphicsSkeleton *)skeleton {
    [skeleton setTextureKey:@"body-femme.png"];
    [skeleton setArmATextureRect:CGRectMake(0.25f, 0.0f, 0.25f, 0.5f)];
    [skeleton setArmBTextureRect:CGRectMake(0.0f, 0.0f, 0.25f, 0.5f)];
    [skeleton setLegATextureRect:CGRectMake(0.25f, 0.5f, 0.25f, 0.5f)];
    [skeleton setLegBTextureRect:CGRectMake(0.0f, 0.5f, 0.25f, 0.5f)];
    [[skeleton torso] setTex:CGRectMake(0.5f, 0.5f, 0.5f, 0.5f)];
    [[skeleton head] setTex:CGRectMake(0.5f, 0.25f, 0.5f, 0.25f)];
}

- (void)configSkeletonBody:(AHPhysicsSkeleton *)skeleton {
    
}

- (AHSkeletonConfig)graphicsConfig {
    AHSkeletonConfig config;
    config.armWidth = 0.20f;
    config.armLength = 0.9f;
    config.legWidth = 0.20f;
    config.legLength = 1.24f;
    config.torsoWidth = 0.28f;
    config.torsoHeight = 0.94f;
    config.headTop = 0.22f;
    config.headBottom = 0.08f;
    config.headLeft = 0.1f;
    config.headRight = 0.15f;
    return config;
}

- (AHSkeletonConfig)physicsConfig {
    return [self graphicsConfig];
}


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    [self updatePhasewalkCheckTurnOff];
}

- (void)updateBeforeRender {
    [self updatePhasewalkCheckTurnOn];
    [self updatePhasewalkXOffset];
}

- (void)updatePhasewalkXOffset {
    cameraPositionX += averageVelocityX;
    xOffset = fmaxf(0.0f, [self heroPosition].x - cameraPositionX);
    // debug
    //xOffset = 0.0f;
}

- (void)updatePhasewalkCheckTurnOff {
    if ([_phasewalkState isState:STATE_IS_PHASEWALKING]) {
        GLKVector2 difference = GLKVector2Subtract(_targetPosition, [self heroPosition]);
        float distance = GLKVector2Length(difference);
        if (distance < PHASEWALK_DISTANCE_TO_CANCEL) {
            //[_phasewalkState changeState:STATE_CAN_PHASEWALK];
            [_phasewalkState changeState:STATE_CANNOT_PHASEWALK];
        }
    } else if (xOffset > 0.0f) {
        [_phasewalkState changeState:STATE_CANNOT_PHASEWALK];
    } else {
        [_phasewalkState changeState:STATE_CAN_PHASEWALK];
    }                      
}

- (void)updatePhasewalkCheckTurnOn {
    if (_needsToPhasewalk) {
        _timeStartedPhasewalk = [[AHTimeManager manager] worldTime];
        [_phasewalkState changeState:STATE_IS_PHASEWALKING];
        cameraPositionX = [self heroPosition].x;
        xOffset = 0.0f;
    }
    _needsToPhasewalk = NO;
}


#pragma mark -
#pragma mark input


- (void)touchBeganAtPoint:(GLKVector2)point {
    if ([_phasewalkState isState:STATE_CAN_PHASEWALK]) {
        _targetPosition = [[AHGraphicsManager camera] screenToWorld:point];
        _needsToPhasewalk = YES;
    }
}


#pragma mark -
#pragma mark states


- (void)stateChangedTo:(int)newState {
    switch ((BCFemmePhasewalkState) newState) {
        case STATE_IS_PHASEWALKING:
            if ([self hero]) {
                [[[self hero] body] setStatic:NO];
                [[[self hero] body] setSensor:YES];
            }
            break;
        case STATE_CAN_PHASEWALK:
            if ([self hero]) {
                [[[self hero] body] setStatic:NO];
                [[[self hero] body] setSensor:NO];
            }
            break;
        case STATE_CANNOT_PHASEWALK:
            if ([self hero]) {
                [[[self hero] body] setStatic:YES];
                [[[self hero] body] setSensor:NO];
            }
            break;
    }
}


#pragma mark -
#pragma mark velocity


- (GLKVector2)modifyVelocity:(GLKVector2)velocity {
    //return GLKVector2Zero();
    if ([_phasewalkState isState:STATE_IS_PHASEWALKING]) {
        return [self velocityToPoint:_targetPosition withMax:PHASEWALK_VELOCITY];
    } else {
        averageVelocityX = velocity.x * [[AHTimeManager manager] worldSecondsPerFrame];
        return velocity;
    }
}


#pragma mark -
#pragma mark collision


- (BOOL)willCollideWithAnyObstacle {
    if ([_phasewalkState isState:STATE_IS_PHASEWALKING]) {
        return NO;
    }
    return YES;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    [_phasewalkState cleanupAfterRemoval];
    _phasewalkState = nil;
    [super cleanupAfterRemoval];
}


#pragma mark -
#pragma mark camera


- (GLKVector2)modifyCameraPosition:(GLKVector2)heroPosition {
    //return heroPosition;
    return GLKVector2Subtract(heroPosition, GLKVector2Make(xOffset, 0.0f));
}


@end
