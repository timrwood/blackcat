//
//  BCBackgroundActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsRect.h"

#import "BCGlobalManager.h"
#import "BCBackgroundActor.h"


@implementation BCBackgroundActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _top = [[AHGraphicsRect alloc] init];
        _mid = [[AHGraphicsRect alloc] init];
        _bot = [[AHGraphicsRect alloc] init];
        [self addComponent:_top];
        [self addComponent:_mid];
        [self addComponent:_bot];
        
        float width = [[UIScreen mainScreen] bounds].size.height; // MOVE THIS UISCREEN TO A GLOBAL OBJECT
        float height = [[UIScreen mainScreen] bounds].size.width; // MOVE THIS UISCREEN TO A GLOBAL OBJECT
        
        [_top setRect:CGRectMake(0.0f, 0.0f, width, height)];
        [_mid setRect:CGRectMake(0.0f, 0.0f, width, height)];
        [_bot setRect:CGRectMake(0.0f, 0.0f, width, height)];
        
        [_top setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_mid setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_bot setTex:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        
        [_top setTextureKey:@"background.png"];
        [_mid setTextureKey:@"background.png"];
        [_bot setTextureKey:@"background.png"];
    }
    return self;
}


@end
