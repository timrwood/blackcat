//
//  SKTimeline.h
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AHSkeletonStruct.h"


@class SKStartEndControl;
@class SKPoseView;
@class SKDocument;


@interface SKTimeline : NSView {
@private;
    CGRect rect;
    
    NSTimer *timer;
    
    NSMutableArray *keyframes;
    
    SKStartEndControl *_startControl;
    SKStartEndControl *_endControl;
    SKStartEndControl *_currentControl;
}


#pragma mark -
#pragma mark properties


@property (weak, nonatomic) SKPoseView *pose;
@property (weak) SKDocument *document;


#pragma mark -
#pragma mark init


- (void)initStartEnd;


#pragma mark -
#pragma mark timer


- (void)play;
- (void)pause;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark add remove


- (BOOL)addKeyframe;


#pragma mark -
#pragma mark update start end


- (void)updateCurrentFrame;
- (void)updateStartEnd;
- (void)updateRect;
- (void)updateKeyframes;
- (void)removeKeyframe;


#pragma mark -
#pragma mark skeleton change


- (void)skeletonChanged;


#pragma mark -
#pragma mark data


- (NSMutableDictionary *)dictionaryForSkeleton:(AHSkeleton)skeleton;
- (AHSkeleton)skeletonForDictionary:(NSDictionary *)dict;
- (NSData *)keyframeData;
- (void)setKeyframeData:(NSData *)data;


#pragma mark -
#pragma mark copy paste


- (void)copy;
- (void)paste;
- (void)cut;


@end
