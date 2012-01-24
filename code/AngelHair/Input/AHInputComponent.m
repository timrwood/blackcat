//
//  AHInputComponent.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHMathUtils.h"
#import "AHInputComponent.h"
#import "AHGraphicsManager.h"
#import "AHInputManager.h"


@implementation AHInputComponent


#pragma mark -
#pragma mark init


- (id)initWithScreenRect:(CGRect)newRect {
	self = [super init];
	if (self) {
        _rect = newRect;
	}
	return self;
}

- (id)init {
	self = [super init];
	if (self) {
        
	}
	return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [[AHInputManager manager] addInputComponent:self];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    [[AHInputManager manager] removeInputComponent:self];
    _delegate = nil;
    [super cleanupAfterRemoval];
}


#pragma mark -
#pragma mark rect


- (void)setScreenRect:(CGRect)newRect {
    _rect = newRect;
}

- (void)setWorldRect:(CGRect)newRect {
    GLKVector2 position = [[AHGraphicsManager camera] worldToScreen:CGPointToGLKVector2(newRect.origin)];
    newRect.origin = GLKVector2ToCGPoint(position);
    _rect = newRect;
}

- (BOOL)containsPoint:(GLKVector2)point {
    return CGRectContainsPoint(_rect, GLKVector2ToCGPoint(point));
}


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHInputDelegate> *)newDelegate {
    if ([newDelegate conformsToProtocol:@protocol(AHInputDelegate)]) {
        _delegate = newDelegate;
    }
}


#pragma mark -
#pragma mark touches


- (void)touchBeganAtPoint:(GLKVector2)point {
    if (_delegate && [_delegate respondsToSelector:@selector(touchBegan)]) {
        [_delegate touchBegan];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(touchBeganAtPoint:)]) {
        [_delegate touchBeganAtPoint:point];
    }
    _initialPoint = point;
    _isInside = YES;
}

- (void)touchMovedAtPoint:(GLKVector2)point {
    if (_isInside && ![self containsPoint:point]) {
        if (_delegate && [_delegate respondsToSelector:@selector(touchLeft)]) {
            [_delegate touchLeft];
        }
        _isInside = NO;
    }
    if (!_isInside && [self containsPoint:point]) {
        if (_delegate && [_delegate respondsToSelector:@selector(touchEntered)]) {
            [_delegate touchEntered];
        }
        _isInside = YES;
    }
    
    GLKVector2 amountMoved = point;
    amountMoved.x -= _initialPoint.x;
    amountMoved.y -= _initialPoint.y;
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchMoved:)]) {
        [_delegate touchMoved:amountMoved];
    }
}

- (void)touchEndedAtPoint:(GLKVector2)point {
    if ([self containsPoint:point]) {
        if (_delegate && [_delegate respondsToSelector:@selector(touchEndedInside)]) {
            [_delegate touchEndedInside];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(touchEndedOutside)]) {
            [_delegate touchEndedOutside];
        }
    }
    _isInside = NO;
}


@end
