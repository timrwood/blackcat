//
//  BCBuildingActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHGraphicsRect.h"
#import "AHPhysicsRect.h"
#import "AHMathUtils.h"

#import "BCGlobalTypes.h"
#import "BCBuildingActor.h"


@implementation BCBuildingActor


#pragma mark -
#pragma mark init


- (id)initFromSize:(CGSize)size andPosition:(GLKVector2)position {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsRect alloc] initFromSize:size andPosition:position];
        [_body setStatic:YES];
        [_body setCategory:PHY_CAT_BUILDING];
        [_body addTag:PHY_TAG_JUMPABLE];
        [self addComponent:_body];
        
        _skin = [[AHGraphicsRect alloc] init];
        [_skin setRectFromCenter:position andSize:size];
        [_skin setTextureKey:@"debug-grid.png"];
        [_skin setTexFromCenter:GLKVector2Make(0.5f, 0.5f) andRadius:0.5f];
        [_skin setLayerIndex:GFK_LAYER_BUILDINGS];
        [self addComponent:_skin];
        
        _distanceCoveredRight = position.x + size.width;
        _distanceCoveredLeft = position.x - size.width;
        _height = position.y - 5.0f; // THIS NEEDS TO NOT BE AN INLINE CONSTANT
    }
    return self;
}


#pragma mark -
#pragma mark coverage


- (void)setPrevHeight:(float)prevHeight {
    _prevHeight = prevHeight;
}

- (void)setSpacing:(float)spacing {
    _spacing = spacing;
}

- (float)distanceCovered {
    return _distanceCoveredRight;
}

- (float)height {
    return _height;
}

- (float)heightAtPosition:(float)position {
    float endOfPrev = _distanceCoveredLeft - _spacing;
    
    if (position < endOfPrev) {
        return _prevHeight;
    } else if (position < _distanceCoveredLeft) {
        float percent = (position - endOfPrev) / _spacing;
        return FloatLerp(_prevHeight, _height, percent);
    } else {
        return _height;
    }
}


@end
