//
//  AHScene.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


@class AHButton;


@interface AHScene : NSObject {
@private;
}


#pragma mark -
#pragma mark buttons


- (void)addButtonsFromJSONFile:(NSString *)filename;
- (void)addButtonFromDictionary:(NSDictionary *)dictionary;
- (void)addButton:(AHButton *)button;


#pragma mark -
#pragma mark setup


- (void)setup;
- (void)resetSetup;


#pragma mark -
#pragma mark update


- (void)update;
- (void)reset;


#pragma mark -
#pragma mark teardown


- (void)teardown;
- (void)resetTeardown;


#pragma mark -
#pragma mark button


- (void)buttonWasTapped:(AHButton *)button;


@end
