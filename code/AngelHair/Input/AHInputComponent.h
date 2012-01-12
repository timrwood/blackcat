//
//  AHInputComponent.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"


@protocol AHInputDelegate <NSObject>


@optional


- (void)touchBegan;
- (void)touchBeganAtPoint:(CGPoint)point;
- (void)touchEndedOutside;
- (void)touchEndedInside;
- (void)touchEntered;
- (void)touchLeft;
- (void)touchMoved:(CGPoint)point;


@end


@interface AHInputComponent : AHActorComponent {
@private;
    CGRect _rect;
    CGPoint _initialPoint;
    NSObject <AHInputDelegate> *_delegate;
    BOOL _isInside;
}


#pragma mark -
#pragma mark init


- (id)initWithScreenRect:(CGRect)newRect;


#pragma mark -
#pragma mark rect


- (void)setScreenRect:(CGRect)newRect;
- (void)setWorldRect:(CGRect)newRect;
- (BOOL)containsPoint:(CGPoint)point;


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHInputDelegate> *)newDelegate;


#pragma mark -
#pragma mark touches


- (void)touchBeganAtPoint:(CGPoint)point;
- (void)touchMovedAtPoint:(CGPoint)point;
- (void)touchEndedAtPoint:(CGPoint)point;


@end
