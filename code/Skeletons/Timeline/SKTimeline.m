//
//  SKTimeline.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define KEYFRAME_MAX 400
#define FRAMERATE 1.0f / 30.0f


#import "SKKeyframe.h"
#import "SKStartEndControl.h"
#import "SKTimeline.h"


@implementation SKTimeline


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self initStartEnd];
        rect = CGRectMake(0.0f, 0.0f, 600.0f, 40.0f);
        [self updateRect];
        keyframes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initStartEnd {
    _startControl = [[SKStartEndControl alloc] init];
    _endControl = [[SKStartEndControl alloc] init];
    _currentControl = [[SKStartEndControl alloc] init];
    
    // set initial values
    [_startControl setMin:0];
    [_endControl setMax:KEYFRAME_MAX];
    [_startControl setFrameId:0];
    [_endControl setFrameId:59];
    
    // set timelines
    [_currentControl setTimeline:self];
    [_startControl setTimeline:self];
    [_endControl setTimeline:self];
    
    // set styles
    [_endControl setEnd];
    [_startControl setStart];
    [_currentControl setCurrent];
    [self updateStartEnd];
    
    // add subviews
    [self addSubview:_startControl];
    [self addSubview:_endControl];
    [self addSubview:_currentControl];
}


#pragma mark -
#pragma mark dragging


- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return YES;
}

- (void)mouseDown:(NSEvent *)event {
    [_currentControl mouseDown:event];
}

- (void)mouseDragged:(NSEvent *)event {
    [_currentControl mouseDragged:event];
}

- (void)mouseUp:(NSEvent *)event {
    [_currentControl mouseUp:event];
}


#pragma mark -
#pragma mark timer


- (void)play {
    if (timer) {
        return;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:FRAMERATE
                                             target:self
                                           selector:@selector(update)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)pause {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


#pragma mark -
#pragma mark update


- (void)update {
    int _currentFrame = [_currentControl frameId] + 1;
    if (_currentFrame > [_endControl frameId]) {
        _currentFrame = [_startControl frameId];
    }
    [_currentControl setFrameId:_currentFrame];
    NSLog(@"_currentFrame %i", _currentFrame);
}


#pragma mark -
#pragma mark add remove


- (void)addKeyframe {
    SKKeyframe *keyframe = [[SKKeyframe alloc] init];
    [keyframe setMin:0];
    [keyframe setMax:KEYFRAME_MAX];
    [keyframe setFrameId:[_currentControl frameId]];
    [self addSubview:keyframe positioned:NSWindowBelow relativeTo:nil];
    [keyframes addObject:keyframe];
}


#pragma mark -
#pragma mark update start end


- (void)updateStartEnd {
    [_endControl setMin:[_startControl frameId] + 1];
    [_startControl setMax:[_endControl frameId] - 1];
    [_currentControl setMin:[_startControl frameId]];
    [_currentControl setMax:[_endControl frameId]];
    [_currentControl setFrameId:[_currentControl frameId]];
    [self updateRect];
}

- (void)updateRect {
    rect.size.width = [_endControl frameId] * 10.0f + 100.0f;
    self.frame = rect;
    
    // superview
    CGRect superRect = self.superview.frame;
    superRect.size.width = rect.size.width;
    self.superview.frame = superRect;
}


@end
