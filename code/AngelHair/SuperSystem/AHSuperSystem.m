//
//  AHSuperSystem.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSuperSystem.h"

#import "AHTimeManager.h"
#import "AHTextureManager.h"
#import "AHGraphicsManager.h"
#import "AHActorManager.h"
#import "AHPhysicsManager.h"
#import "AHFileManager.h"
#import "AHSceneManager.h"
#import "AHInputManager.h"

// #import "AHAnimationManager.h"


static AHSuperSystem *_manager = nil;


@implementation AHSuperSystem


#pragma mark -
#pragma mark singleton


+ (AHSuperSystem *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [[AHTimeManager manager] setup];
    [[AHInputManager manager] setup];
    [[AHFileManager manager] setup];
    [[AHSceneManager manager] setup];
    [[AHPhysicsManager manager] setup];
    [[AHTextureManager manager] setup];
    [[AHGraphicsManager manager] setup];
    //[[AHAnimationManager manager] setup];
    [[AHActorManager manager] setup];
}


#pragma mark -
#pragma mark teardown


- (void)enterBackground {
    
}

- (void)teardown {
    [[AHActorManager manager] teardown];
    //[[AHAnimationManager manager] teardown];
    [[AHGraphicsManager manager] teardown];
    [[AHTextureManager manager] teardown];
    [[AHPhysicsManager manager] teardown];
    [[AHSceneManager manager] teardown];
    [[AHFileManager manager] teardown];
    [[AHInputManager manager] teardown];
    [[AHTimeManager manager] teardown];
}


#pragma mark -
#pragma mark cleanCache


- (void)cleanCache {
    [[AHTextureManager manager] cleanCache];
}


#pragma mark -
#pragma mark update


- (void)update {
    [[AHTimeManager manager] update];
    // physics
    [[AHActorManager manager] updateBeforePhysics];
    [[AHPhysicsManager manager] update];
    
    // animation
    [[AHActorManager manager] updateBeforeAnimation];
    //[[AHAnimationManager manager] update];
    
    // render
    [[AHActorManager manager] updateBeforeRender];
    [[AHGraphicsManager manager] update];
    
    // end update
    [[AHSceneManager manager] update];
    [[AHActorManager manager] updateAfterEverything];
}


#pragma mark -
#pragma mark draw


- (void)draw {
    [[AHGraphicsManager manager] draw];
    
    if (_isEnabledDebugDraw) {
        [[AHPhysicsManager manager] drawDebug];
    }
}
        
- (void)setDebugDraw:(BOOL)enableDebugDraw {
    _isEnabledDebugDraw = enableDebugDraw;
}


@end
