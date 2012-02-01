//
//  AHAnimationSkeletonCache.m
//  BlackCat
//
//  Created by Tim Wood on 1/19/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHFileManager.h"
#import "AHAnimationSkeletonTrack.h"
#import "AHAnimationSkeletonCache.h"


static AHAnimationSkeletonCache *_manager = nil;


@interface AHAnimationSkeletonCache()


- (AHAnimationSkeletonTrack *)loadAnimationForKey:(NSString *)key;


@end


@implementation AHAnimationSkeletonCache


#pragma mark -
#pragma mark singleton


+ (AHAnimationSkeletonCache *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark animations


- (AHAnimationSkeletonTrack *)animationForKey:(NSString *)key {
    AHAnimationSkeletonTrack *track = (AHAnimationSkeletonTrack *)[_cache objectForKey:key];
    if (!track) {
        track = [self loadAnimationForKey:key];
        [_cache setObject:track forKey:key];
    }
    return track;
}

- (AHAnimationSkeletonTrack *)loadAnimationForKey:(NSString *)key {
    NSArray *keyframes = [[AHFileManager manager] parseJSONFromResourceFileToArray:[key stringByAppendingPathExtension:@"anim"]];
    AHAnimationTimeTrack *timeTrack = [[AHAnimationTimeTrack alloc] initWithSize:[keyframes count]];
    AHAnimationSkeletonTrack *track = [[AHAnimationSkeletonTrack alloc] initWithSize:[keyframes count]];
    [track setTimeTrack:timeTrack];
    int i = 0;
    float lastTime;
    float thisTime;
    for (NSDictionary *dict in keyframes) {
        if (![dict isKindOfClass:[NSDictionary class]]) {
            derror(@"Child of array is not dictionary. %@", key);
        }
        
        thisTime = [[dict objectForKey:@"time"] floatValue];
        
        if (thisTime > 0.0f && thisTime < lastTime) {
            derror(@"Time cannot be greater than last time. Frame %i Times %F %F %@", i, lastTime, thisTime, key);
        }
        
        [timeTrack setTime:thisTime atIndex:i];
        [track setValueFromDictionary:dict atIndex:i];
        lastTime = thisTime;
        i++;
    }
    return track;
}


@end

