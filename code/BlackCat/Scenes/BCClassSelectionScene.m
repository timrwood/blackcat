//
//  BCClassSelectionScene.m
//  BlackCat
//
//  Created by Tim Wood on 1/30/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


typedef enum {
    CLASS_A,
    CLASS_B,
    CLASS_C
} BCClassSelectionType;


#import "AHButton.h"
#import "BCClassSelectionScene.h"


@implementation BCClassSelectionScene



#pragma mark -
#pragma mark setup


- (void)setup {
    [self addButtonsFromJSONFile:@"class-selection.scene"];
}


#pragma mark -
#pragma mark setup


- (void)buttonWasTapped:(AHButton *)button {
    switch ((BCClassSelectionType) [button identifier]) {
        case CLASS_A:
            dlog(@"choosing a");
            break;
        case CLASS_B:
            dlog(@"choosing b");
            break;
        case CLASS_C:
            dlog(@"choosing c");
            break;
        default:
            dlog(@"error out of bounds");
            break;
    }
}


@end
