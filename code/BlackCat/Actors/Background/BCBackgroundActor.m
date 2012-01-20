//
//  BCBackgroundActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"

#import "BCGlobalTypes.h"
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
        
        [_top addToLayerIndex:(int)GFX_LAYER_BACKGROUND];
        [_mid addToLayerIndex:(int)GFX_LAYER_BACKGROUND];
        [_bot addToLayerIndex:(int)GFX_LAYER_BACKGROUND];
        
        [_top setTextureKey:@"background.png"];
        [_mid setTextureKey:@"background.png"];
        [_bot setTextureKey:@"background.png"];
        
        topMidTexSize = CGSizeMake(1.0f, 3.0f / 8.0f);
        bottomTexSize = CGSizeMake(1.0f, 5.0f / 16.0f);
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeRender {
    [self updatePosition];
    [self updateTexture];
}

- (void)updatePosition {
    CGSize size = [[AHGraphicsManager camera] worldSize];
    CGPoint center = [[AHGraphicsManager camera] worldPosition];
    
    CGSize bottomSize = size;
    CGSize topMidSize = size;
    
    CGPoint topCenter = center;
    CGPoint midCenter = center;
    CGPoint botCenter = center;
    
    // debug
    bottomSize.width *= 0.5f;
    topMidSize.width *= 0.5f;
    midCenter.x += 1.0f;
    botCenter.x += 2.0f;
    
    bottomSize.height *= 0.5f;
    topMidSize.height *= 5.0f / 12.0f;
    
    topCenter.y -= (7.0f / 12.0f) * size.height;
    midCenter.y -= (1.0f / 12.0f) * size.height;
    botCenter.y += (1.0f / 2.0f) * size.height;
    
    //dlog(@"pos %.3F %.3f size %.3F %.3f", topCenter.x, topCenter.y, topMidSize.width, topMidSize.height);
    
    [_top setRectFromCenter:topCenter andSize:topMidSize];
    [_mid setRectFromCenter:midCenter andSize:topMidSize];
    [_bot setRectFromCenter:botCenter andSize:bottomSize];
}

- (void)updateTexture {
    [_top setTexFromCenter:CGPointMake(0.5f, 0.5f) andSize:topMidTexSize];
    [_mid setTexFromCenter:CGPointMake(0.5f, 0.5f) andSize:topMidTexSize];
    [_bot setTexFromCenter:CGPointMake(0.5f, 0.5f) andSize:bottomTexSize];
}


@end
