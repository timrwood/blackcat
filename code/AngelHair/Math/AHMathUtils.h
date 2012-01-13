//
//  AHMathUtils.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


@interface AHMathUtils : NSObject


#pragma mark -
#pragma mark percent between


+ (float)percent:(float)percent
   betweenFloatA:(float)floatA 
       andFloatB:(float)floatB;
+ (CGPoint)percent:(float)percent 
     betweenPointA:(CGPoint)pointA 
         andPointB:(CGPoint)pointB;


@end
