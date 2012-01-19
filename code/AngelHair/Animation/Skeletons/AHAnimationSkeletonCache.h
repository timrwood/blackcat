//
//  AHAnimationSkeletonCache.h
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


@class AHAnimationSkeletonTrack;


@interface AHAnimationSkeletonCache : NSObject {
@private;
    NSMutableDictionary *_cache;
}


#pragma mark -
#pragma mark singleton


+ (AHAnimationSkeletonCache *)manager;


#pragma mark -
#pragma mark animations


- (AHAnimationSkeletonTrack *)animationForKey:(NSString *)key;


@end
