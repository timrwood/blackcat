//
//  BCHeroTypeBoxer.m
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define EXPLOSION_RADIUS 2.0f

#define DASH_DISTANCE_TO_CANCEL 0.2f
#define DASH_VELOCITY 4.0f

#define DASH_MAX_TIME 0.3f
#define DASH_TIMEOUT 0.3f


#import "AHTimeManager.h"
#import "AHPhysicsBody.h"

#import "BCGlobalTypes.h"
#import "BCHeroActor.h"
#import "BCHeroTypeBoxer.h"


typedef enum {
    STATE_CAN_DASH,
    STATE_CANNOT_DASH,
    STATE_IS_DASHING_UP,
    STATE_IS_DASHING_DOWN,
    STATE_IS_DASHING_RIGHT
} BCBoxerDashState;


@implementation BCHeroTypeBoxer


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _dashState = [[AHLogicState alloc] init];
        [_dashState setDelegate:self];
    }
    return self;
}


#pragma mark -
#pragma mark skin


- (void)configSkeletonSkin:(AHGraphicsSkeleton *)skeleton {
    [skeleton setTextureKey:@"body-boxer.png"];
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
    config.legLength = 1.1f;
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
    [self updateDashCheckTurnOff];
}

- (void)updateBeforeRender {
    [self updateDashCheckTurnOn];
    [self updateDashXOffset];
}

- (void)updateDashXOffset {
    cameraPositionX += averageVelocityX + averageVelocityX;
    xOffset = fmaxf(0.0f, [self heroPosition].x - cameraPositionX);
}

- (void)updateDashCheckTurnOn {
    if (_needsToDash) {
        _timeStartedDash = [[AHTimeManager manager] worldTime];
        [_dashState changeState:_needsToDashState];
        cameraPositionX = [self heroPosition].x;
        xOffset = 0.0f;
    }
    _needsToDash = NO;
}

- (void)updateDashCheckTurnOff {
    if ([self isDashing]) {
        GLKVector2 difference = GLKVector2Subtract(_targetPosition, [self heroPosition]);
        float distance = GLKVector2Length(difference);
        if (distance < DASH_DISTANCE_TO_CANCEL) {
            [_dashState changeState:STATE_CANNOT_DASH];
        }
        //[self sendExplosionMessage:MSG_EXPLOSION_RIGHT withRadius:1.2f];
    } else if (xOffset > 0.0f) {
        [_dashState changeState:STATE_CANNOT_DASH];
    } else {
        [_dashState changeState:STATE_CAN_DASH];
    }
    
    if ([[AHTimeManager manager] worldTime] - _timeStartedDash > DASH_TIMEOUT) {
        [_dashState changeState:STATE_CAN_DASH];
    } else if ([[AHTimeManager manager] worldTime] - _timeStartedDash > DASH_MAX_TIME) {
        [_dashState changeState:STATE_CANNOT_DASH];
    }                 
}


#pragma mark -
#pragma mark velocity


- (GLKVector2)modifyVelocity:(GLKVector2)velocity {
    //return GLKVector2Zero();
    if ([self isDashing]) {
        return [self velocityToPoint:_targetPosition withMax:DASH_VELOCITY];
    } else {
        averageVelocityX = velocity.x * [[AHTimeManager manager] worldSecondsPerFrame];
        return velocity;
    }
}


#pragma mark -
#pragma mark dashing


- (BOOL)isDashing {
    if ([_dashState isState:STATE_CAN_DASH] || 
        [_dashState isState:STATE_CANNOT_DASH]) {
        return NO;
    }
    return YES;
}

- (void)sendExplosionMessage:(int)type withRadius:(float)radius {
    if ([self hero]) {
        [[self hero] sendMessage:[[AHActorMessage alloc] initWithType:type 
                                                             andPoint:[self heroPosition] 
                                                             andFloat:radius]];
    }
}

- (void)dashToPoint:(GLKVector2)point {
    _targetPosition = GLKVector2Add([self heroPosition], point);
}


#pragma mark -
#pragma mark logic


- (void)stateChangedTo:(int)newState {
    switch ((BCBoxerDashState) newState) {
        case STATE_CAN_DASH:
            break;
        case STATE_CANNOT_DASH:
            break;
        case STATE_IS_DASHING_UP:
            [self dashToPoint:GLKVector2Make(0.0f, -4.5f)];
            [self sendExplosionMessage:MSG_EXPLOSION_UP withRadius:EXPLOSION_RADIUS];
            break;
        case STATE_IS_DASHING_DOWN:
            [self dashToPoint:GLKVector2Make(0.0f, 2.0f)];
            [self sendExplosionMessage:MSG_EXPLOSION_DOWN withRadius:EXPLOSION_RADIUS];
            break;
        case STATE_IS_DASHING_RIGHT:
            [self dashToPoint:GLKVector2Make(4.0f, 0.0f)];
            [self sendExplosionMessage:MSG_EXPLOSION_RIGHT withRadius:EXPLOSION_RADIUS];
            break;
    }
}


#pragma mark -
#pragma mark collision

- (BOOL)willCollideWithObstacle:(AHPhysicsBody *)obstacle {
    if ([obstacle hasTag:PHY_TAG_BREAKABLE] && [self isDashing]) {
        if ([_dashState isState:STATE_IS_DASHING_RIGHT]) {
            [self sendExplosionMessage:MSG_EXPLOSION_RIGHT withRadius:1.2f];
        }
        if ([_dashState isState:STATE_IS_DASHING_UP]) {
            [self sendExplosionMessage:MSG_EXPLOSION_UP withRadius:1.2f];
        }
        if ([_dashState isState:STATE_IS_DASHING_DOWN]) {
            [self sendExplosionMessage:MSG_EXPLOSION_DOWN withRadius:1.2f];
        }
        return NO;
    }
    return YES;
}

- (BOOL)willCollideWithAnyObstacle {
    return YES;
}


#pragma mark -
#pragma mark touch


- (void)touchMoved:(GLKVector2)point {
    if (![_dashState isState:STATE_CAN_DASH]) {
        return;
    }
    if (point.x > 3.0f && point.x > fabsf(point.y)) {
        _needsToDash = YES;
        _needsToDashState = STATE_IS_DASHING_RIGHT;
    } else if (point.y > 3.0f) {
        _needsToDash = YES;
        _needsToDashState = STATE_IS_DASHING_DOWN;
    } else if (point.y < -3.0f) {
        _needsToDash = YES;
        _needsToDashState = STATE_IS_DASHING_UP;
    }
}


#pragma mark -
#pragma mark camera


- (GLKVector2)modifyCameraPosition:(GLKVector2)heroPosition {
    GLKVector2 pos = heroPosition;
    pos.x -= xOffset;
    return pos;
}


@end
