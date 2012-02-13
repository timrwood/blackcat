//
//  AHGraphicsCube.h
//  BlackCat
//
//  Created by Tim Wood on 2/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsObject.h"


@interface AHGraphicsCube : AHGraphicsObject {
@private;
    float _startDepth;
    float _endDepth;
    CGRect _rect;
    
    float _offsetYT;
    float _offsetYB;
}


#pragma mark -
#pragma mark rect


- (void)setRightYTopOffset:(float)top andRightYBottomOffset:(float)bot;
- (void)setRectFromCenter:(GLKVector2)center andRadius:(float)radius;
- (void)setRectFromCenter:(GLKVector2)center andSize:(CGSize)size;
- (void)setRect:(CGRect)rect;
- (void)setStartDepth:(float)startDepth endDepth:(float)endDepth;


#pragma mark -
#pragma mark tex


- (void)setTexFromCenter:(GLKVector2)center andRadius:(float)radius;
- (void)setTexFromCenter:(GLKVector2)center andSize:(CGSize)size;
- (void)setTex:(CGRect)rect;
- (void)setTopTex:(CGRect)rect;
- (void)setBotTex:(CGRect)rect;


@end