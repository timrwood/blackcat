//
//  SKDocument.m
//  Skeletons
//
//  Created by Tim Wood on 2/23/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//

#import "SKDocument.h"

@implementation SKDocument


#pragma mark -
#pragma mark properties


@synthesize debugLabel;
@synthesize playButton;
@synthesize speedControl;
@synthesize addKeyframeButton;
@synthesize removeKeyframeButton;


- (id)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SKDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}


#pragma mark -
#pragma mark actions


- (IBAction)pauseResumeAnimaion:(id)sender {
    _isPaused = !_isPaused;
    if (_isPaused) {
        debugLabel.stringValue = @"paused";
    } else {
        debugLabel.stringValue = @"playing";
    }
}

- (IBAction)changePlaybackRate:(id)sender {
    if (sender == self.speedControl) {
        debugLabel.stringValue = [NSString stringWithFormat:@"selected playback rate %i", self.speedControl.selectedSegment];
    }
}

- (IBAction)addKeyframe:(id)sender {
    debugLabel.stringValue = @"add keyframe";
}

- (IBAction)removeKeyframe:(id)sender {
    debugLabel.stringValue = @"remove keyframe";
}


@end
