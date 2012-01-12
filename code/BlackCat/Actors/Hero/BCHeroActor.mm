//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCHeroActor.h"
#import "AHPhysicsCircle.h"
#import "AHGraphicsManager.h"


@implementation BCHeroActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsCircle alloc] initFromRadius:1.0f andPosition:CGPointMake(0.0f, 0.0f)];
        [_body setStatic:NO];
        [self addComponent:_body];
        
        _input = [[AHInputComponent alloc] initWithScreenRect:[[UIScreen mainScreen] bounds]];
        [_input setDelegate:self];
        [self addComponent:_input];
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    // move to right
    float vely = [_body linearVelocity].y;
    [_body setLinearVelocity:CGPointMake(20.0f, vely)];
    
    float cameraYOffset = 1.0f + fmaxf(-8.0f, fminf([_body position].y, 0.0f)) / 2.0f;
    
    CGPoint cameraPos = [_body position];
    cameraPos.x += 3.0f;
    cameraPos.y -= cameraYOffset;
    
    // set camera
    [[AHGraphicsManager camera] setWorldPosition:cameraPos];
}


#pragma mark -
#pragma mark touch


- (void)touchBegan {
    dlog(@"-------------------- hero touch began");
}


@end
