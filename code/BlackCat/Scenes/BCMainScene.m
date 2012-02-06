//
//  BCMainScene.m
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActorManager.h"
#import "AHTimeManager.h"
#import "AHGraphicsManager.h"

#import "BCBackgroundActor.h"
#import "BCHeroRecorderActor.h"
#import "BCHeroPlaybackActor.h"
#import "BCTerrainBuilder.h"
#import "BCHeroActor.h"
#import "BCTerrainCleaner.h"
#import "BCMainScene.h"
#import "BCGlobalManager.h"


@implementation BCMainScene


#pragma mark -
#pragma mark setup


- (void)resetSetup {
    [[AHTimeManager manager] setWorldToRealRatio:1.0f];
    
    [[BCGlobalManager manager] setHeroPosition:GLKVector2Make(0.0f, 0.0f)];
    [[BCGlobalManager manager] setHeroSpeed:0.0f];
    
    [[AHActorManager manager] add:[[BCBackgroundActor alloc] init]];
    [[AHActorManager manager] add:[[BCTerrainBuilder alloc] initWithKey:12345]];
    [[AHActorManager manager] add:[[BCHeroActor alloc] init]];
    [[AHActorManager manager] add:[[BCTerrainCleaner alloc] init]];
    _recorderActor = [[BCHeroRecorderActor alloc] init];
    [[AHActorManager manager] add:_recorderActor];
    
    if (_lastRecording) {
        //[[AHActorManager manager] add:[[BCHeroPlaybackActor alloc] initWithData:_lastRecording]];
         _lastRecording = nil;
    }
}


#pragma mark -
#pragma mark teardown


- (void)resetTeardown {
    if (_recorderActor) {
        _lastRecording = [_recorderActor outputData];
        //dlog(@"%@", [_recorderActor outputData]);
        //dlog(@"%@", [_recorderActor outputString]);
        _recorderActor = nil;
    }
}


@end
