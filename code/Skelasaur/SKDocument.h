//
//  SKDocument.h
//  Skelasaur
//
//  Created by Tim Wood on 2/23/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <Cocoa/Cocoa.h>


@interface SKDocument : NSDocument <NSApplicationDelegate>


#pragma mark -
#pragma mark properties


@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextField *textField;


#pragma mark -
#pragma mark actions


- (IBAction)takeFloatValueForVolumeFrom:(id)sender;


@end
