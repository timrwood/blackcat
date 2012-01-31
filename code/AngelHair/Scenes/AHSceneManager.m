//
//  AHSceneManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorManager.h"
#import "AHSceneManager.h"
#import "AHTimeManager.h"
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
        _timeToFadeIn = 0.5f;
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
    [[AHActorManager manager] destroyAll];
    [[AHActorManager manager] updateAfterEverything];
    [[AHTimeManager manager] reset];
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


- (void)setTimeToFadeIn:(float)time {
    _timeToFadeIn = time;
}

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
        _timeToReset += 0.03f; // change to use global time
        if (_timeToReset > _timeToFadeIn) {
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
        if (_timeToNewScene > _timeToFadeIn) {
            [self goToNextScene];
        }
    } else {
        if (_timeToNewScene > 0.0f) {
            _timeToNewScene -= 0.03f; // change to use global time
        }
    }
}


@end