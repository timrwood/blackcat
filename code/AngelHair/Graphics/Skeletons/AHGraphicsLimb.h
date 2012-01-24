//
//  AHGraphicsLimb.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsObject.h"


@interface AHGraphicsLimb : AHGraphicsObject {
@private;
    float _length;
    float _width;
    float _angle;
    
    BOOL _canUseCache;
}


#pragma mark -
#pragma mark sizes


- (void)setWidth:(float)width;
- (void)setLength:(float)length;
- (void)setAngle:(float)angle;


#pragma mark -
#pragma mark texture


- (void)setTextureRect:(CGRect *)rect;


#pragma mark -
#pragma mark draw


- (void)cacheValues;


@end
