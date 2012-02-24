//
//  SKKeyframe.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "SKTimeline.h"
#import "SKKeyframe.h"


@implementation SKKeyframe

- (id)init {
    self = [super init];
    if (self) {
        [self setBezelStyle:NSSmallSquareBezelStyle];
        [self setTitle:@""];
        rect = CGRectMake(1.0f, 21.0f, 8.0f, 18.0f);
        [self setFrame:rect];
    }
    return self;
}


#pragma mark -
#pragma mark properties


@synthesize timeline;
@synthesize min;
@synthesize max;


#pragma mark -
#pragma mark dragging


- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return YES;
}

- (void)mouseDown:(NSEvent *)event {
    lastDragX = [event locationInWindow].x;
    targetX = rect.origin.x;
}

- (void)mouseDragged:(NSEvent *)event {
    float thisDragX = [event locationInWindow].x;
    targetX += thisDragX - lastDragX;
    [self setFrameId:roundf(targetX / 10.0f)];
    lastDragX = thisDragX;
}

- (void)mouseUp:(NSEvent *)event {
    lastDragX = 0.0f;
    targetX = 0.0f;
}


#pragma mark -
#pragma mark setFrame


- (void)setFrameId:(int)frame {
    int newFrame = fminf(max, fmaxf(frame, min));
    if (newFrame != _frameId) {
        _frameId = newFrame;
        if (timeline) {
            [timeline updateStartEnd];
        }
        rect.origin.x = _frameId * 10.0f + 1.0f;
        [self setFrame:rect];
    }
}

- (int)frameId {
    return _frameId;
}


@end
