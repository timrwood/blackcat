//
//  BCHeroPlaybackActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHActor.h"


@class AHPhysicsCircle;


@interface BCHeroPlaybackActor : AHActor {
@private;
    NSMutableArray *_frames;
    int _currentIndex;
    AHPhysicsCircle *_body;
}


#pragma mark -
#pragma mark init


- (id)initWithData:(NSData *)data;


@end
