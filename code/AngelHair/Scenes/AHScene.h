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
    NSMutableArray *buttons;
}


#pragma mark -
#pragma mark buttons


- (void)addButtonsFromJSONFile:(NSString *)filename;
- (void)addButtonFromDictionary:(NSDictionary *)dictionary;
- (void)addButton:(AHButton *)button;
- (void)removeButton:(AHButton *)button;
- (void)removeAllButtons;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark teardown


- (void)teardown;


@end
