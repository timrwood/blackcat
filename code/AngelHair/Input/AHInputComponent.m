//
//  AHInputComponent.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


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
    dlog(@"setup");
    [[AHInputManager manager] addInputComponent:self];
}


#pragma mark -
#pragma mark rect


- (void)setScreenRect:(CGRect)newRect {
    _rect = newRect;
}

- (void)setWorldRect:(CGRect)newRect {
    CGPoint position = [[AHGraphicsManager camera] worldToScreen:newRect.origin];
    newRect.origin = position;
    _rect = newRect;
}

- (BOOL)containsPoint:(CGPoint)point {
    dlog(@"checking contains point");
    return CGRectContainsPoint(_rect, point);
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


- (void)touchBeganAtPoint:(CGPoint)point {
    if (_delegate && [_delegate respondsToSelector:@selector(touchBegan)]) {
        [_delegate touchBegan];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(touchBeganAtPoint:)]) {
        [_delegate touchBeganAtPoint:point];
    }
    _initialPoint = point;
    _isInside = YES;
}

- (void)touchMovedAtPoint:(CGPoint)point {
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
    
    CGPoint amountMoved = point;
    amountMoved.x -= _initialPoint.x;
    amountMoved.y -= _initialPoint.y;
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchMoved:)]) {
        [_delegate touchMoved:amountMoved];
    }
}

- (void)touchEndedAtPoint:(CGPoint)point {
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
