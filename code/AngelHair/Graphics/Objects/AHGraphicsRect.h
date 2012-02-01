//
//  AHGraphicsRect.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHGraphicsObject.h"


@interface AHGraphicsRect : AHGraphicsObject {

}


#pragma mark -
#pragma mark rect


- (void)setRectFromCenter:(GLKVector2)center andRadius:(float)radius;
- (void)setRectFromCenter:(GLKVector2)center andSize:(CGSize)size;
- (void)setRect:(CGRect)rect;


#pragma mark -
#pragma mark tex


- (void)setTexFromCenter:(GLKVector2)center andRadius:(float)radius;
- (void)setTexFromCenter:(GLKVector2)center andSize:(CGSize)size;
- (void)setTex:(CGRect)rect;


@end
