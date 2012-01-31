//
//  AHButton.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHInputManager.h"
#import "AHGraphicsManager.h"
#import "AHScene.h"
#import "AHButton.h"


@implementation AHButton


#pragma mark -
#pragma mark init


- (id)initFromRectDictionary:(NSDictionary *)rDict andTexDictionary:(NSDictionary *)tDict {
    int rx = [[rDict objectForKey:@"rx"] intValue];
    int ry = [[rDict objectForKey:@"ry"] intValue];
    int rw = [[rDict objectForKey:@"rw"] intValue];
    int rh = [[rDict objectForKey:@"rh"] intValue];
    
    float tx = [[tDict objectForKey:@"tx"] floatValue];
    float ty = [[tDict objectForKey:@"ty"] floatValue];
    float tw = [[tDict objectForKey:@"tw"] floatValue];
    float th = [[tDict objectForKey:@"th"] floatValue];
    
    NSString *key = [tDict objectForKey:@"key"];
    int identifier = [[tDict objectForKey:@"id"] intValue];
    
    return [self initFromRect:CGRectMake(rx, ry, rw, rh)
                   andTexRect:CGRectMake(tx, ty, tw, th) 
                    andTexKey:key 
                        andId:identifier];
}

- (id)initFromRect:(CGRect)rect
        andTexRect:(CGRect)tex
         andTexKey:(NSString *)key
             andId:(int)identifier {
    self = [super init];
    _rect = _rect;
    _identifier = identifier;
    
    // graphics
    _graphics = [[AHGraphicsRect alloc] init];
    [_graphics setRect:rect];
    [_graphics setTex:tex];
    [_graphics setTextureKey:key];
    [self addComponent:_graphics];
    [[AHGraphicsManager manager] addObjectToHUDLayer:_graphics];
    
    // input
    _input = [[AHInputComponent alloc] initWithScreenRect:rect];
    [self addComponent:_input];
    [[AHInputManager manager] addInputComponent:_input];
    [_input setDelegate:self];
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


@end
