//
//  AHSkeletonStruct.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHMathUtils.h"


typedef struct _AHSkeleton {
	float x;
	float y;
	float neck;
    float shoulderA;
    float shoulderB;
    float elbowA;
    float elbowB;
	float waist;
    float hipA;
    float hipB;
    float kneeA;
    float kneeB;
} AHSkeleton;


static inline AHSkeleton AHSkeletonAdd(AHSkeleton skeletonA, AHSkeleton skeletonB) {
    return (AHSkeleton) {
        skeletonA.x +         skeletonB.x,
        skeletonA.y +         skeletonB.y,
        skeletonA.neck +      skeletonB.neck,
        skeletonA.shoulderA + skeletonB.shoulderA,
        skeletonA.shoulderB + skeletonB.shoulderB,
        skeletonA.elbowA +    skeletonB.elbowA,
        skeletonA.elbowB +    skeletonB.elbowB,
        skeletonA.waist +     skeletonB.waist,
        skeletonA.hipA +      skeletonB.hipA,
        skeletonA.hipB +      skeletonB.hipB,
        skeletonA.kneeA +     skeletonB.kneeA,
        skeletonA.kneeB +     skeletonB.kneeB
    };
}

static inline AHSkeleton AHSkeletonMultiply(AHSkeleton skeleton, float percent) {
	return (AHSkeleton) {
        skeleton.x *         percent,
        skeleton.y *         percent,
        skeleton.neck *      percent,
        skeleton.shoulderA * percent,
        skeleton.shoulderB * percent,
        skeleton.elbowA *    percent,
        skeleton.elbowB *    percent,
        skeleton.waist *     percent,
        skeleton.hipA *      percent,
        skeleton.hipB *      percent,
        skeleton.kneeA *     percent,
        skeleton.kneeB *     percent
    };
}

static inline AHSkeleton AHSkeletonLerp(AHSkeleton skeletonA, AHSkeleton skeletonB, float percent) {
    return AHSkeletonAdd(AHSkeletonMultiply(skeletonA, percent),
                         AHSkeletonMultiply(skeletonB, 1.0f - percent));
}

static inline AHSkeleton AHSkeletonModRotationBetween(AHSkeleton skelIn, float lower, float upper) {
    AHSkeleton skelOut = skelIn;
    skelOut.waist     = FloatModBetween(skelIn.waist,     lower, upper);
    skelOut.neck      = FloatModBetween(skelIn.neck,      lower, upper);
    skelOut.shoulderA = FloatModBetween(skelIn.shoulderA, lower, upper);
    skelOut.shoulderB = FloatModBetween(skelIn.shoulderB, lower, upper);
    skelOut.elbowA    = FloatModBetween(skelIn.elbowA,    lower, upper);
    skelOut.elbowB    = FloatModBetween(skelIn.elbowB,    lower, upper);
    skelOut.hipA      = FloatModBetween(skelIn.hipA,      lower, upper);
    skelOut.hipB      = FloatModBetween(skelIn.hipB,      lower, upper);
    skelOut.kneeA     = FloatModBetween(skelIn.kneeA,     lower, upper);
    skelOut.kneeB     = FloatModBetween(skelIn.kneeB,     lower, upper);
    return skelOut;
}

static inline AHSkeleton AHSkeletonZero() {
    return (AHSkeleton) {
        0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f
    };
}

typedef struct _AHSkeletonConfig {
	float torsoWidth;
	float torsoHeight;
    float legWidth;
    float legLength;
    float armWidth;
	float armLength;
    float headLeft;
    float headRight;
    float headTop;
    float headBottom;
} AHSkeletonConfig;

