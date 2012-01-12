//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsCircle.h"
#import "AHGraphicsManager.h"
#import "AHInputManager.h"

#import "BCHeroActor.h"
#import "BCGlobalManager.h"


@implementation BCHeroActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsCircle alloc] initFromRadius:0.5f andPosition:CGPointMake(0.0f, 0.0f)];
        [_body setRestitution:0.1f];
        [_body setStatic:NO];
        [_body setDelegate:self];
        [self addComponent:_body];
        
        _input = [[AHInputComponent alloc] initWithScreenRect:[[UIScreen mainScreen] bounds]];
        [_input setDelegate:self];
        [self addComponent:_input];
        
        _runSpeed = 5.0f;
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    // velocity
    float vely = [_body linearVelocity].y;
    _runSpeed += 0.02f;
    if (vely > 0.0f) {
        vely *= 1.2f; // travelling downward
    } else {
        vely /= 1.4f; // travelling upward
    }
    [_body setLinearVelocity:CGPointMake(_runSpeed, vely)];
    [[BCGlobalManager manager] setHeroSpeed:_runSpeed];
    
    // camera
    float cameraYOffset = - 2.0f + fmaxf(3.0f, fminf([_body position].y, 5.0f)) / 2.0f;
    dlog(@"camera y offset %F %F", [_body position].y, cameraYOffset);
    
    CGPoint cameraPos = [_body position];
    cameraPos.x += 20.0f;
    cameraPos.y -= cameraYOffset * 4.0f;
    
    [[AHGraphicsManager camera] setWorldPosition:cameraPos];
    [[AHGraphicsManager camera] setWorldZoom:40.0f];
}


#pragma mark -
#pragma mark touch


- (void)touchBegan {
    if (_canJump) {
        float velx = [_body linearVelocity].x;
        [_body setLinearVelocity:CGPointMake(velx, -30.0f)];
        _canJump = NO;
    }
}


#pragma mark -
#pragma mark contacts


- (BOOL)collidedWith:(AHPhysicsBody *)contact {
    _canJump = YES;
    return YES;
}


@end
