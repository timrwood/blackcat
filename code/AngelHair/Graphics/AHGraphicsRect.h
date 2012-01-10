//
//  AHGraphicsRect.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsObject.h"


@interface AHGraphicsRect : AHGraphicsObject <AHActorComponent> {

}


#pragma mark -
#pragma mark rect


- (void)setRectFromCenter:(CGPoint)center andRadius:(float)radius;
- (void)setRectFromCenter:(CGPoint)center andSize:(CGSize)size;
- (void)setRect:(CGRect)rect;


#pragma mark -
#pragma mark tex


- (void)setTexFromCenter:(CGPoint)center andRadius:(float)radius;
- (void)setTexFromCenter:(CGPoint)center andSize:(CGSize)size;
- (void)setTex:(CGRect)rect;


@end
