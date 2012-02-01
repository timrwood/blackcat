//
//  BCBackgroundActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define TEX_TOP_Y_CENTER 5.0f / 32.0f
#define TEX_MID_Y_CENTER 15.0f / 32.0f
#define TEX_BOT_Y_CENTER 13.0f / 16.0f

#define TEX_TOP_X_OFFSET_RATIO 1.0f / 200.0f
#define TEX_MID_X_OFFSET_RATIO 1.0f / 100.0f
#define TEX_BOT_X_OFFSET_RATIO 1.0f / 50.0f

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
        
        [_top setLayerIndex:GFX_LAYER_BACKGROUND];
        [_mid setLayerIndex:GFX_LAYER_BACKGROUND];
        [_bot setLayerIndex:GFX_LAYER_BACKGROUND];
        
        [_top setTextureKey:@"background.png"];
        [_mid setTextureKey:@"background.png"];
        [_bot setTextureKey:@"background.png"];
        
        [self addComponent:_top];
        [self addComponent:_mid];
        [self addComponent:_bot];
        
        topMidTexSize = CGSizeMake(0.5f, 5.0f / 32.0f);
        bottomTexSize = CGSizeMake(0.5f, 3.0f / 16.0f);
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
    GLKVector2 center = [[AHGraphicsManager camera] worldPosition];
    
    CGSize bottomSize = size;
    CGSize topMidSize = size;
    
    GLKVector2 topCenter = center;
    GLKVector2 midCenter = center;
    GLKVector2 botCenter = center;
    
    bottomSize.height *= 0.5f;
    topMidSize.height *= 5.0f / 12.0f;
    
    topCenter.y -= (7.0f / 12.0f) * size.height;
    midCenter.y -= (1.0f / 12.0f) * size.height;
    botCenter.y += (1.0f / 2.0f) * size.height;
    
    [_top setRectFromCenter:topCenter andSize:topMidSize];
    [_mid setRectFromCenter:midCenter andSize:topMidSize];
    [_bot setRectFromCenter:botCenter andSize:bottomSize];
}

- (void)updateTexture {
    float heroX = [[AHGraphicsManager camera] worldPosition].x;
    
    float topX = fmodf(heroX * TEX_TOP_X_OFFSET_RATIO, 1.0f);
    float midX = fmodf(heroX * TEX_MID_X_OFFSET_RATIO, 1.0f);
    float botX = fmodf(heroX * TEX_BOT_X_OFFSET_RATIO, 1.0f);
    
    [_top setTexFromCenter:GLKVector2Make(topX, TEX_TOP_Y_CENTER) andSize:topMidTexSize];
    [_mid setTexFromCenter:GLKVector2Make(midX, TEX_MID_Y_CENTER) andSize:topMidTexSize];
    [_bot setTexFromCenter:GLKVector2Make(botX, TEX_BOT_Y_CENTER) andSize:bottomTexSize];
}


@end
