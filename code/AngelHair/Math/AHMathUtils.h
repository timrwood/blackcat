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
    
    
#define M_TAU     M_PI * 2.0f
#define M_TAU_2   M_PI
#define M_TAU_4   M_PI_2
#define M_TAU_8   M_PI_4
#define M_TAU_16  M_PI_4 * 0.5f
#define M_TAU_32  M_PI_4 * 0.25f
    
    
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
    
    
#pragma mark -
#pragma mark rotation
    
    static __inline__ GLKVector2 GLKVector2MakeFromRotationAndLength(float rotation, float length);
    static __inline__ GLKVector2 GLKVector2MakeFromRotationAndLength(float rotation, float length) {
        float cosR = cosf(rotation);
        float sinR = sinf(rotation);
        return GLKVector2Make(length * cosR, length * sinR);
    }
    
    static __inline__ GLKVector2 GLKVector2Rotate(GLKVector2 point, float rotation);
    static __inline__ GLKVector2 GLKVector2Rotate(GLKVector2 point, float rotation) {
        float cosR = cosf(rotation);
        float sinR = sinf(rotation);
        return GLKVector2Make(point.x * cosR - point.y * sinR, 
                              point.x * sinR + point.y * cosR);
    }
    
    static __inline__ GLKVector2 GLKVector2RotateAroundVector(GLKVector2 point, GLKVector2 origin, float rotation);
    static __inline__ GLKVector2 GLKVector2RotateAroundVector(GLKVector2 point, GLKVector2 origin, float rotation) {
        /*GLKVector2 subtract = GLKVector2Subtract(point, origin);
        dlog(@"subtract %@", NSStringFromGLKVector2(subtract));
        GLKVector2 rotate = GLKVector2Rotate(subtract, rotation);
        dlog(@"rotate %@", NSStringFromGLKVector2(rotate));
        GLKVector2 add = GLKVector2Add(origin, rotate);
        dlog(@"add %@", NSStringFromGLKVector2(add));
        return add;*/
        return GLKVector2Add(origin, GLKVector2Rotate(GLKVector2Subtract(point, origin), rotation));
    }
    
#ifdef __cplusplus
}
#endif
    
#endif