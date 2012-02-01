//
//  BCTerrainCleaner.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActor.h"


@interface BCTerrainCleaner : AHActor {
@private;
    int _updatesSinceLastCleanup;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupWorld;


@end
