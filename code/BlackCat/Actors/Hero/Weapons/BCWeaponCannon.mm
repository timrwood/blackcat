//
//  BCWeaponCannon.m
//  BlackCat
//
//  Created by Tim Wood on 2/14/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define MISSILE_WIDTH 0.1f
#define MISSILE_HEIGHT 0.05f

#define MISSILE_BLAST_RADIUS 2.0f

#define MAX_TIME_TO_LIVE 1.0f


#import "AHTimeManager.h"
#import "AHMathUtils.h"
#import "AHPhysicsRect.h"

#import "BCGlobalTypes.h"
#import "BCWeaponCannon.h"


@implementation BCWeaponCannon


#pragma mark -
#pragma mark init


- (id)initAtPosition:(GLKVector2)position andVelocity:(GLKVector2)velocity {
    self = [super init];
    if (self) {
        CGSize size = CGSizeMake(MISSILE_WIDTH, MISSILE_HEIGHT);
        float rotation = atan2f(velocity.y, velocity.x);
        GLKVector2 modPos = GLKVector2MultiplyScalar(velocity, [[AHTimeManager manager] worldSecondsPerFrame]);
        modPos = GLKVector2Add(modPos, position);
        
        _body = [[AHPhysicsRect alloc] init];
        [_body setSize:size andPosition:modPos];
        [_body setSensor:YES];
        [_body setStatic:NO];
        [_body setLinearVelocity:velocity];
        [_body setRotation:rotation];
        [_body setFixedRotation:YES];
        [_body setDelegate:self];
        [_body ignoreCategory:PHY_CAT_HERO];
        [_body ignoreCategory:PHY_CAT_DEBRIS];
        [_body setBullet:YES];
        [self addComponent:_body];
        
        _skin = [[AHGraphicsCube alloc] init];
        [_skin setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setTopTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setBotTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_skin setTextureKey:@"debug-grid.png"];
        [_skin setRectFromCenter:GLKVector2Zero() andSize:size];
        [_skin setPosition:modPos];
        [_skin setStartDepth:Z_PHYSICS_DEPTH + MISSILE_HEIGHT endDepth:Z_PHYSICS_DEPTH - MISSILE_HEIGHT];
        [self addComponent:_skin];
        [_skin setRotation:rotation];
        
        _timeCreated = [[AHTimeManager manager] worldTime];
        
        _velocity = velocity;
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics {
    [_body setLinearVelocity:_velocity];
}

- (void)updateBeforeRender {
    [_skin setRotation:[_body rotation]];
    [_skin setPosition:[_body position]];
    
    if ([[AHTimeManager manager] worldTime] - _timeCreated > MAX_TIME_TO_LIVE) {
        [self safeDestroy];
        //dlog(@"destroying cannon as it lived too long");
    }
}


#pragma mark -
#pragma mark contact


- (BOOL)collidedWith:(AHPhysicsBody *)contact {
    [self sendMessage:[[AHActorMessage alloc] initWithType:MSG_EXPLOSION_ALL
                                                  andPoint:[_body position]
                                                  andFloat:MISSILE_BLAST_RADIUS]];
    [self safeDestroy];
    return YES;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    _skin = nil;
    _body = nil;
    [super cleanupBeforeDestruction];
}


@end
