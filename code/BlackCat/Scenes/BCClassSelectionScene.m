//
//  BCClassSelectionScene.m
//  BlackCat
//
//  Created by Tim Wood on 1/30/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHButton.h"
#import "AHSceneManager.h"

#import "BCGlobalManager.h"
#import "BCMainScene.h"
#import "BCClassSelectionScene.h"


@implementation BCClassSelectionScene



#pragma mark -
#pragma mark setup


- (void)setup {
    [self addButtonsFromJSONFile:@"class-selection.scene"];
    [super setup];
}


#pragma mark -
#pragma mark setup


- (void)buttonWasTapped:(AHButton *)button {
    [[BCGlobalManager manager] setHeroType:(BCHeroTypes) [button identifier]];
    [[AHSceneManager manager] goToScene:[[BCMainScene alloc] init]];
}


@end
