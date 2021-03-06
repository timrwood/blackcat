//
//  AHInputManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHSubSystem.h"


@class AHInputComponent;


@interface AHInputManager : NSObject <AHSubSystem> {
@private;
    NSMutableDictionary *_touchDict;
    NSMutableArray *_components;
}


#pragma mark -
#pragma mark singleton


+ (AHInputManager *)manager;


#pragma mark -
#pragma mark inputs


- (void)addInputComponent:(AHInputComponent *)input;
- (void)removeInputComponent:(AHInputComponent *)input;
- (void)removeAllInputComponents;


#pragma mark -
#pragma mark touches

- (GLKVector2)pointForTouch:(UITouch *)touch;
- (void)touchBegan:(UITouch *)touch;
- (void)touchMoved:(UITouch *)touch;
- (void)touchEnded:(UITouch *)touch;


@end