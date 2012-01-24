//
//  AHMathUtils.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#ifndef __AH_MATH_UTILS_H
#define __AH_MATH_UTILS_H

#include <stdbool.h>
#include <math.h>

#ifdef __cplusplus
extern "C" {
#endif
    

#pragma mark -
#pragma mark constants


#define M_TAU M_PI * 2.0f


#pragma mark -
#pragma mark float lerp


// get the percent between start and end for the center value
static __inline__ float FloatPercentBetween(float start, float end, float center);

// lerp a float
static __inline__ float FloatLerp(float start, float end, float t);


#pragma mark -
#pragma mark implimentations


static __inline__ float FloatPercentBetween(float start, float end, float center) {
    return (center - start) / (end - start);
}

static __inline__ float FloatLerp(float start, float end, float t) {
    return start + ((end - start) * t);
}


#pragma mark -
#pragma mark conversions

static __inline__ GLKVector2 CGPointToGLKVector2(CGPoint point);
static __inline__ GLKVector2 CGPointToGLKVector2(CGPoint point) {
    return GLKVector2Make(point.x, point.y);
}

static __inline__ CGPoint GLKVector2ToCGPoint(GLKVector2 point);
static __inline__ CGPoint GLKVector2ToCGPoint(GLKVector2 point) {
    return CGPointMake(point.x, point.y);
}

    
#ifdef __cplusplus
}
#endif
    
#endif