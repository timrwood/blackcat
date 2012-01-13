//
//  AHMathUtils.m
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHMathUtils.h"


@implementation AHMathUtils


#pragma mark -
#pragma mark percent between


+ (float)percent:(float)percent 
   betweenFloatA:(float)floatA 
       andFloatB:(float)floatB {
    return floatA + (floatB - floatA) * percent;
}

+ (CGPoint)percent:(float)percent 
     betweenPointA:(CGPoint)pointA 
         andPointB:(CGPoint)pointB {
    CGPoint output;
    output.x = [self percent:percent betweenFloatA:pointA.x andFloatB:pointB.x];
    output.y = [self percent:percent betweenFloatA:pointA.y andFloatB:pointB.y];
    return output;
}


@end
