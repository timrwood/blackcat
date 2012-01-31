//
//  AHButton.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHScene.h"
#import "AHButton.h"


@implementation AHButton


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        // graphics
        _graphics = [[AHGraphicsRect alloc] init];
        [self addComponent:_graphics];
        [_graphics setHudLayer:YES];
        
        // input
        _input = [[AHInputComponent alloc] init];
        [self addComponent:_input];
        [_input setDelegate:self];
    }
    return self;
}

- (id)initFromRectDictionary:(NSDictionary *)rDict andTexDictionary:(NSDictionary *)tDict {
    self = [self init];
    if (self) {
        int rx = [[rDict objectForKey:@"rx"] intValue];
        int ry = [[rDict objectForKey:@"ry"] intValue];
        int rw = [[rDict objectForKey:@"rw"] intValue];
        int rh = [[rDict objectForKey:@"rh"] intValue];
        CGRect screenRect = CGRectMake(rx, ry, rw, rh);
        [_graphics setRect:screenRect];
        [_input setScreenRect:screenRect];
        
        float tx = [[tDict objectForKey:@"tx"] floatValue];
        float ty = [[tDict objectForKey:@"ty"] floatValue];
        float tw = [[tDict objectForKey:@"tw"] floatValue];
        float th = [[tDict objectForKey:@"th"] floatValue];
        [_graphics setTex:CGRectMake(tx, ty, tw, th)];
        
        NSString *key = [tDict objectForKey:@"key"];
        [_graphics setTextureKey:key];
        
        int identifier = [[tDict objectForKey:@"id"] intValue];
        _identifier = identifier;
    }
    return self;
}

- (id)initFromRect:(CGRect)rect
        andTexRect:(CGRect)tex
         andTexKey:(NSString *)key
             andId:(int)identifier {
    self = [self init];
    if (self) {
        [_graphics setRect:rect];
        [_input setScreenRect:rect];
        [_graphics setTex:tex];
        [_graphics setTextureKey:key];
        _identifier = identifier;
    }
    return self;
}


#pragma mark -
#pragma mark scene


- (void)setScene:(AHScene *)scene {
    _scene = scene;
}


#pragma mark -
#pragma mark touch


- (void)touchBegan {
    [_graphics setPosition:GLKVector2Make(0.0f, 3.0f)];
}

- (void)touchLeft {
    [_graphics setPosition:GLKVector2Make(0.0f, 0.0f)];
}

- (void)touchEntered {
    [_graphics setPosition:GLKVector2Make(0.0f, 3.0f)];
}

- (void)touchEndedInside {
    if (_scene) {
        [_scene buttonWasTapped:self];
    }
    [_graphics setPosition:GLKVector2Make(0.0f, 0.0f)];
}

- (void)touchEndedOutside {
    [_graphics setPosition:GLKVector2Make(0.0f, 0.0f)];
}


#pragma mark -
#pragma mark identifier


- (int)identifier {
    return _identifier;
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupBeforeDestruction {
    _scene = nil;
    _graphics = nil;
    _input = nil;
    [super cleanupBeforeDestruction];
}


@end
