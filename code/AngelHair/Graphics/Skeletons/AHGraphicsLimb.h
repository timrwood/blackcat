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
    float _upperLength;
    float _lowerLength;
    float _width;
    float _jointPercent;
}


#pragma mark -
#pragma mark sizes


- (void)setWidth:(float)width;
- (void)setUpperLength:(float)upper;
- (void)setLowerLength:(float)lower;
- (void)setJointPercent:(float)percent;


#pragma mark -
#pragma mark texture


- (void)setTextureRect:(CGRect *)rect;


@end
