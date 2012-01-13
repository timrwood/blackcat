//
//  AHSceneManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSubSystem.h"


@class AHScene;


@interface AHSceneManager : NSObject <AHSubSystem> {
@private;
    AHScene *_currentScene;
    AHScene *_nextScene;
    
    float _timeToNewScene;
    float _timeToReset;
    BOOL _needsToBeReset;
}


#pragma mark -
#pragma mark singleton


+ (AHSceneManager *)manager;


#pragma mark -
#pragma mark reset


- (void)reset;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark scenes


- (void)goToScene:(AHScene *)scene;
- (void)goToNextScene;


@end
