//
//  BCMainScene.m
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorManager.h"
#import "AHGraphicsManager.h"

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
    [[BCGlobalManager manager] setHeroPosition:CGPointZero];
    [[BCGlobalManager manager] setHeroSpeed:0.0f];
    
    [[AHActorManager manager] add:[[BCTerrainBuilder alloc] initWithKey:12345]];
    [[AHActorManager manager] add:[[BCHeroActor alloc] init]];
    [[AHActorManager manager] add:[[BCTerrainCleaner alloc] init]];
    _recorderActor = [[BCHeroRecorderActor alloc] init];
    [[AHActorManager manager] add:_recorderActor];
    
    if (_lastRecording) {
        [[AHActorManager manager] add:[[BCHeroPlaybackActor alloc] initWithData:_lastRecording]];
         _lastRecording = nil;
    }
}


#pragma mark -
#pragma mark teardown


- (void)resetTeardown {
    if (_recorderActor) {
        _lastRecording = [_recorderActor outputData];
        //dlog(@"%@", _lastRecording);
        //dlog(@"%@", [_recorderActor outputString]);
        _recorderActor = nil;
    }
}


@end
