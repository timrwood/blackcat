//
//  AHInputComponent.h
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHActorComponent.h"


@protocol AHInputDelegate <NSObject>


@optional


- (void)touchBegan;
- (void)touchBeganAtPoint:(GLKVector2)point;
- (void)touchEndedOutside;
- (void)touchEndedInside;
- (void)touchEntered;
- (void)touchLeft;
- (void)touchMoved:(GLKVector2)point;


@end


@interface AHInputComponent : AHActorComponent {
@private;
    CGRect _rect;
    GLKVector2 _initialPoint;
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
- (BOOL)containsPoint:(GLKVector2)point;


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHInputDelegate> *)newDelegate;


#pragma mark -
#pragma mark touches


- (void)touchBeganAtPoint:(GLKVector2)point;
- (void)touchMovedAtPoint:(GLKVector2)point;
- (void)touchEndedAtPoint:(GLKVector2)point;


@end
