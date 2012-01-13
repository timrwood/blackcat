//
//  BCMainScene.m
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorManager.h"
#import "AHGraphicsManager.h"

#import "BCTerrainBuilder.h"
#import "BCHeroActor.h"
#import "BCTerrainCleaner.h"
#import "BCMainScene.h"
#import "BCGlobalManager.h"


@implementation BCMainScene


- (void)resetSetup {
    dlog(@"called reset setup");
    [[BCGlobalManager manager] setHeroPosition:CGPointZero];
    [[BCGlobalManager manager] setHeroSpeed:0.0f];
    
    [[AHActorManager manager] add:[[BCTerrainBuilder alloc] init]];
    [[AHActorManager manager] add:[[BCHeroActor alloc] init]];
    [[AHActorManager manager] add:[[BCTerrainCleaner alloc] init]];
}

- (void)resetTeardown {
    dlog(@"called reset teardown");
}


@end
