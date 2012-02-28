//
//  SKDocument.m
//  Skeletons
//
//  Created by Tim Wood on 2/23/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "SKTimeline.h"
#import "SKPoseView.h"
#import "SKDocument.h"


@implementation SKDocument


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _pose = [[SKPoseView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 580.0f, 290.0f)];
        _timeline = [[SKTimeline alloc] init];
        [_timeline setPose:_pose];
        [_timeline setDocument:self];
    }
    return self;
}


#pragma mark -
#pragma mark properties


@synthesize playButton;
@synthesize speedControl;
@synthesize addKeyframeButton;
@synthesize removeKeyframeButton;
@synthesize keyframeView;
@synthesize poserView;


- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SKDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    [keyframeView addSubview:_timeline];
    [_timeline updateRect];
    [poserView addSubview:_pose];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return [_timeline keyframeData];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    [_timeline setKeyframeData:data];
    return YES;
}


#pragma mark -
#pragma mark actions


- (IBAction)pauseResumeAnimaion:(id)sender {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
        [_timeline play];
    } else {
        [_timeline pause];
    }
}

- (IBAction)changePlaybackRate:(id)sender {
    
}

- (IBAction)addKeyframe:(id)sender {
    [_timeline addKeyframe];
}

- (IBAction)removeKeyframe:(id)sender {
    [_timeline removeKeyframe];
}


#pragma mark -
#pragma mark copy paste


- (IBAction)copy:(id)sender {
    [_timeline copy];
}

- (IBAction)paste:(id)sender {
    [_timeline paste];
}

- (IBAction)cut:(id)sender {
    [_timeline cut];
}


@end
