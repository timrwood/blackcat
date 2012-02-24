//
//  SKDocument.h
//  Skeletons
//
//  Created by Tim Wood on 2/23/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SKDocument : NSDocument <NSApplicationDelegate> {
@private;
    BOOL _isPaused;
}


#pragma mark -
#pragma mark properties


@property (weak) IBOutlet NSTextField *debugLabel;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSSegmentedControl *speedControl;
@property (weak) IBOutlet NSButton *addKeyframeButton;
@property (weak) IBOutlet NSButton *removeKeyframeButton;


#pragma mark -
#pragma mark actions


- (IBAction)pauseResumeAnimaion:(id)sender;
- (IBAction)changePlaybackRate:(id)sender;
- (IBAction)addKeyframe:(id)sender;
- (IBAction)removeKeyframe:(id)sender;


@end
