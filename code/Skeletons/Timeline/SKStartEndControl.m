//
//  SKStartEndControl.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "SKStartEndControl.h"
#import "SKTimeline.h"


@implementation SKStartEndControl


- (id)init {
    self = [super init];
    if (self) {
        [self setBordered:NO];
        [self setTitle:@""];
        rect = CGRectMake(0.0f, 0.0f, 10.0f, 40.0f);
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
    CGRect r = [timeline convertRect:[timeline bounds] toView:nil];
    targetX = [event locationInWindow].x - r.origin.x;
    [self setFrameId:roundf(targetX / 10.0f)];
}

- (void)mouseDragged:(NSEvent *)event {
    float thisDragX = [event locationInWindow].x;
    targetX += thisDragX - lastDragX;
    [self setFrameId:floorf(targetX / 10.0f)];
    lastDragX = thisDragX;
}

- (void)mouseUp:(NSEvent *)event {
    lastDragX = 0.0f;
    targetX = 0.0f;
    if (_isCurrent) {
        [timeline updateCurrentFrame];
    }
}


#pragma mark -
#pragma mark draw


- (void)drawRect:(NSRect)dirtyRect {
    [color setFill];
    CGRect r = dirtyRect;
    if (_isEnd || _isStart) {
        r.size.width = 4.0f;
        r.origin.x += 1.0f;
    }
    if (_isEnd) {
        r.origin.x += 4.0f;
    }
    
    NSRectFillUsingOperation(r, NSCompositeSourceAtop);
    
    [super drawRect:dirtyRect];
}


#pragma mark -
#pragma mark setFrame


- (void)setCurrent {
    color = [NSColor colorWithDeviceRed:0.0f 
                                  green:0.0f 
                                   blue:0.0f 
                                  alpha:0.1f];
    //rect = CGRectMake(0.0f, 0.0f, 10.0f, 30.0f);
    //[self setFrame:rect];
    _isCurrent = YES;
    
}

- (void)setStart {
    color = [NSColor colorWithDeviceRed:0.0f 
                                  green:0.0f 
                                   blue:0.0f 
                                  alpha:0.9f];
    _isStart = YES;
}

- (void)setEnd {
    color = [NSColor colorWithDeviceRed:0.0f 
                                  green:0.0f 
                                   blue:0.0f 
                                  alpha:0.9f];
    _isEnd = YES;
}

- (void)setFrameId:(int)frame {
    int newFrame = fminf(max, fmaxf(frame, min));
    if (newFrame != _frameId) {
        _frameId = newFrame;
        if (timeline) {
            [timeline updateStartEnd];
            if (_isCurrent) {
                [timeline updateCurrentFrame];
            }
        }
        rect.origin.x = _frameId * 10.0f;
        [self setFrame:rect];
    }
}

- (int)frameId {
    return _frameId;
}


@end
