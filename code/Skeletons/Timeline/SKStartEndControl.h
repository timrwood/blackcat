//
//  SKStartEndControl.h
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <Foundation/Foundation.h>


@class SKTimeline;


@interface SKStartEndControl : NSButton {
    float lastDragX;
    float targetX;
    
    CGRect rect;
    NSColor *color;
    
    int _frameId;
    
    BOOL _isEnd;
    BOOL _isStart;
    BOOL _isCurrent;
}


#pragma mark -
#pragma mark properties


@property (strong) SKTimeline *timeline;
@property (assign) int min;
@property (assign) int max;


#pragma mark -
#pragma mark setFrame


- (void)setCurrent;
- (void)setStart;
- (void)setEnd;
- (void)setFrameId:(int)frame;
- (int)frameId;


@end
