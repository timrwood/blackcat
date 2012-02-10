//
//  BCHeroTypeFemme.mm
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define PHASEWALK_DISTANCE_TO_CANCEL 1.0f
#define PHASEWALK_VELOCITY 3.0f

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
    config.legLength = 1.0f;
    config.torsoWidth = 0.28f;
    config.torsoHeight = 0.6f;
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
    if ([_phasewalkState isState:STATE_IS_PHASEWALKING]) {
        GLKVector2 difference = GLKVector2Subtract(_targetPosition, [self heroPosition]);
        float distance = GLKVector2Length(difference);
        if (distance < PHASEWALK_DISTANCE_TO_CANCEL) {
            [_phasewalkState changeState:STATE_CANNOT_PHASEWALK];
        }
    } else if (xOffset > 0.0f) {
        [_phasewalkState changeState:STATE_CANNOT_PHASEWALK];
    } else {
        [_phasewalkState changeState:STATE_CAN_PHASEWALK];
    }
    
    if ([_phasewalkState isState:STATE_IS_PHASEWALKING]) {
        xOffset = [self heroPosition].x - cameraPositionX;
    } else {
        xOffset = fmaxf(xOffset - 0.2f, 0.0f);
    }
}


#pragma mark -
#pragma mark input


- (void)touchBeganAtPoint:(GLKVector2)point {
    if ([_phasewalkState isState:STATE_CAN_PHASEWALK]) {
        _timeStartedPhasewalk = [[AHTimeManager manager] worldTime];
        [_phasewalkState changeState:STATE_IS_PHASEWALKING];
        _targetPosition = [[AHGraphicsManager camera] screenToWorld:point];
        cameraPositionX = [self heroPosition].x;
        xOffset = 0.0f;
        dlog(@"xoffset %F", xOffset);
        //dlog(@"!!phasewalk!! %@", NSStringFromGLKVector2([[[self hero] body] position]));
    } else {
        dlog(@"cannot phasewalk now");
    }
}


#pragma mark -
#pragma mark states


- (void)stateChangedTo:(int)newState {
    switch ((BCFemmePhasewalkState) newState) {
        case STATE_IS_PHASEWALKING:
            if ([self hero]) {
                [[[self hero] body] setSensor:YES];
            }
            break;
        case STATE_CAN_PHASEWALK:
            if ([self hero]) {
                [[[self hero] body] setSensor:NO];
            }
            break;
        case STATE_CANNOT_PHASEWALK:
            if ([self hero]) {
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
    GLKVector2 pos = heroPosition;
    pos.x -= xOffset;
    return pos;
}


@end
