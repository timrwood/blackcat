//
//  AHSkeletonStruct.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


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

static inline AHSkeleton AHSkeletonAtPercentToSkeleton(AHSkeleton skeletonA, AHSkeleton skeletonB, float percent) {
    return AHSkeletonAdd(AHSkeletonMultiply(skeletonA, percent),
                         AHSkeletonMultiply(skeletonB, 1.0f - percent));
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

