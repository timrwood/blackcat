//
//  BCHeroPlaybackActor.h
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHActor.h"


@class AHPhysicsCircle;
@class AHAnimationPointTrack;


@interface BCHeroPlaybackActor : AHActor {
@private;
    AHAnimationPointTrack *_position;
    AHPhysicsCircle *_body;
}


#pragma mark -
#pragma mark init


- (id)initWithData:(NSData *)data;


#pragma mark -
#pragma mark data


- (void)unpackData:(NSData *)data;
- (float)unpackFloatFromData:(NSData *)data atOffset:(int)offset;


@end
