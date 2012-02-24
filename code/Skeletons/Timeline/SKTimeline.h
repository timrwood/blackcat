//
//  SKTimeline.h
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <Foundation/Foundation.h>


@class SKStartEndControl;


@interface SKTimeline : NSView {
@private;
    CGRect rect;
    
    NSTimer *timer;
    
    NSMutableArray *keyframes;
    
    SKStartEndControl *_startControl;
    SKStartEndControl *_endControl;
    SKStartEndControl *_currentControl;
}


#pragma mark -
#pragma mark init


- (void)initStartEnd;


#pragma mark -
#pragma mark timer


- (void)play;
- (void)pause;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark add remove


- (void)addKeyframe;


#pragma mark -
#pragma mark update start end


- (void)updateStartEnd;
- (void)updateRect;


@end
