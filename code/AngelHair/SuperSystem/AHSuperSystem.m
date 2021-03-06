//
//  AHSuperSystem.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <GLKit/GLKit.h>
#import "AHSuperSystem.h"

#import "AHTimeManager.h"
#import "AHTextureManager.h"
#import "AHGraphicsManager.h"
#import "AHActorManager.h"
#import "AHParticleManager.h"
#import "AHPhysicsManager.h"
#import "AHFileManager.h"
#import "AHSceneManager.h"
#import "AHShaderManager.h"
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
        _isEnabledRenderDraw = YES;
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
    [[AHShaderManager manager] setup];
    [[AHParticleManager manager] setup];
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
    [[AHParticleManager manager] teardown];
    [[AHShaderManager manager] teardown];
    [[AHGraphicsManager manager] teardown];
    [[AHTextureManager manager] teardown];
    [[AHPhysicsManager manager] teardown];
    [[AHSceneManager manager] teardown];
    [[AHFileManager manager] teardown];
    [[AHInputManager manager] teardown];
    [[AHTimeManager manager] teardown];
}


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHSuperSystemDelegate> *)delegate {
    _delegate = delegate;
}


#pragma mark -
#pragma mark cleanCache


- (void)cleanCache {
    [[AHTextureManager manager] cleanCache];
}


#pragma mark -
#pragma mark update


- (void)update {
    if (_isPaused) {
        return;
    }
    
    [[AHTimeManager manager] update];
    // physics
    [[AHActorManager manager] updateBeforePhysics];
    if (_delegate) {
        [_delegate updateBeforePhysics];
    }
    [[AHPhysicsManager manager] update];
    
    // animation
    [[AHActorManager manager] updateBeforeAnimation];
    [[AHParticleManager manager] update];
    if (_delegate) {
        [_delegate updateBeforeAnimation];
    }
    //[[AHAnimationManager manager] update];
    
    // render
    [[AHActorManager manager] updateBeforeRender];
    if (_delegate) {
        [_delegate updateBeforeRender];
    }
    [[AHGraphicsManager manager] update];
    
    // end update
    [[AHSceneManager manager] update];
    [[AHActorManager manager] updateAfterEverything];
    if (_delegate) {
        [_delegate updateAfterEverything];
    }
}


#pragma mark -
#pragma mark draw


- (void)draw {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if (_isEnabledRenderDraw) {
        [[AHShaderManager manager] useTextureProgram];
        
        // draw graphics manager
        glPushGroupMarkerEXT(0, "Graphics Manager Draw");
        [[AHGraphicsManager manager] draw];
        glPopGroupMarkerEXT();
        
        // draw particle manager
        glPushGroupMarkerEXT(0, "Particle Manager Draw");
        [[AHParticleManager manager] draw];
        glPopGroupMarkerEXT();
    }
    
    if (_isEnabledDebugDraw) {
        [[AHShaderManager manager] useColorProgram];
        glPushGroupMarkerEXT(0, "Debug Draw");
        [[AHPhysicsManager manager] drawDebug];
        glPopGroupMarkerEXT();
    }
}
        
- (void)setDebugDraw:(BOOL)enableDebugDraw {
    _isEnabledDebugDraw = enableDebugDraw;
}

- (void)setRenderDraw:(BOOL)enableRenderDraw {
    _isEnabledRenderDraw = enableRenderDraw;
}


#pragma mark -
#pragma mark pause


- (void)pause {
    _isPaused = YES;
}

- (void)resume {
    _isPaused = NO;
}


@end
