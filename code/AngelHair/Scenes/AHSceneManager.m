//
//  AHSceneManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define TIME_TO_FADE_IN 0.5f


#import "AHSceneManager.h"
#import "AHScene.h"


static AHSceneManager *_manager = nil;


@interface AHSceneManager()


#pragma mark -
#pragma mark private update


- (void)updateResetTimer;
- (void)updateNextSceneTimer;


@end


@implementation AHSceneManager


#pragma mark -
#pragma mark singleton


+ (AHSceneManager *)manager {
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
#pragma mark scenes


- (void)goToScene:(AHScene *)scene {
    // if there is no scene yet, set as current
    if (!_currentScene) {
        _currentScene = scene;
        [_currentScene setup];
    } else {
        _nextScene = scene;
    }
}

- (void)goToNextScene {
    [_currentScene teardown];
    [_nextScene setup];
    
    _currentScene = _nextScene;
    _nextScene = nil;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    [_currentScene teardown];
}


#pragma mark -
#pragma mark reset


- (void)reset {
    _needsToBeReset = YES;
}


#pragma mark -
#pragma mark update


- (void)update {
    [self updateResetTimer];
    [self updateNextSceneTimer];
    [_currentScene update];
}


#pragma mark -
#pragma mark private update


- (void)updateResetTimer {
    if (_needsToBeReset) {
        dlog(@"need reset");
        _timeToReset += 0.03f; // change to use global time
        if (_timeToReset > TIME_TO_FADE_IN) {
            [_currentScene reset];
            _needsToBeReset = NO;
        }
    } else {
        if (_timeToReset > 0.0f) {
            _timeToReset -= 0.03f; // change to use global time
        }
    }
}
- (void)updateNextSceneTimer {
    if (_nextScene) {
        _timeToNewScene += 0.03f; // change to use global time
        if (_timeToNewScene > TIME_TO_FADE_IN) {
            [self goToNextScene];
        }
    } else {
        if (_timeToNewScene > 0.0f) {
            _timeToNewScene -= 0.03f; // change to use global time
        }
    }
}

@end