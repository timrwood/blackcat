//
//  SKKeyframe.h
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <Foundation/Foundation.h>


@class SKTimeline;


@interface SKKeyframe : NSButton {
    float lastDragX;
    float targetX;
    
    CGRect rect;
    
    int _frameId;
}


#pragma mark -
#pragma mark properties


@property (weak) SKTimeline *timeline;
@property (assign) int min;
@property (assign) int max;


#pragma mark -
#pragma mark setFrame


- (void)setFrameId:(int)frame;
- (int)frameId;

@end
