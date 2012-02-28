//
//  SKTimeline.m
//  Skeletons
//
//  Created by Tim Wood on 2/24/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#define KEYFRAME_MAX 400
#define FRAMERATE 1.0f / 30.0f


#import "SKDocument.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "SKKeyframe.h"
#import "SKStartEndControl.h"
#import "SKTimeline.h"
#import "SKPoseView.h"


@implementation SKTimeline


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        [self initStartEnd];
        rect = CGRectMake(0.0f, 0.0f, 600.0f, 40.0f);
        [self updateRect];
        keyframes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initStartEnd {
    _startControl = [[SKStartEndControl alloc] init];
    _endControl = [[SKStartEndControl alloc] init];
    _currentControl = [[SKStartEndControl alloc] init];
    
    // set initial values
    [_startControl setMin:0];
    [_endControl setMax:KEYFRAME_MAX];
    [_startControl setFrameId:0];
    [_endControl setFrameId:59];
    
    // set timelines
    [_currentControl setTimeline:self];
    [_startControl setTimeline:self];
    [_endControl setTimeline:self];
    
    // set styles
    [_endControl setEnd];
    [_startControl setStart];
    [_currentControl setCurrent];
    [self updateStartEnd];
    
    // add subviews
    [self addSubview:_startControl];
    [self addSubview:_endControl];
    [self addSubview:_currentControl];
}


#pragma mark -
#pragma mark properties


@synthesize pose = _pose;
@synthesize document;

- (void)setPose:(SKPoseView *)pose {
    [pose setTimeline:self];
    _pose = pose;
}


#pragma mark -
#pragma mark dragging


- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return YES;
}

- (void)mouseDown:(NSEvent *)event {
    [_currentControl mouseDown:event];
}

- (void)mouseDragged:(NSEvent *)event {
    [_currentControl mouseDragged:event];
}

- (void)mouseUp:(NSEvent *)event {
    [_currentControl mouseUp:event];
}


#pragma mark -
#pragma mark timer


- (void)play {
    if (timer) {
        return;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:FRAMERATE
                                             target:self
                                           selector:@selector(update)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)pause {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


#pragma mark -
#pragma mark update


- (void)update {
    int _currentFrame = [_currentControl frameId] + 1;
    if (_currentFrame > [_endControl frameId]) {
        _currentFrame = [_startControl frameId];
    }
    [_currentControl setFrameId:_currentFrame];
    [self updateCurrentFrame];
}


#pragma mark -
#pragma mark add remove


- (BOOL)addKeyframe {
    for (SKKeyframe *keyframe in keyframes) {
        if ([keyframe frameId] == [_currentControl frameId]) {
            NSLog(@"already a keyframe here");
            return NO;
        }
    }
    
    SKKeyframe *keyframe = [[SKKeyframe alloc] init];
    [keyframe setMin:0];
    [keyframe setMax:KEYFRAME_MAX];
    [keyframe setFrameId:[_currentControl frameId]];
    [self addSubview:keyframe positioned:NSWindowBelow relativeTo:nil];
    [keyframes addObject:keyframe];
    [keyframe setSkeleton:[[self pose] skeleton]];
    [self updateKeyframes];
    return YES;
}


#pragma mark -
#pragma mark update start end


- (void)updateStartEnd {
    [_endControl setMin:[_startControl frameId] + 1];
    [_startControl setMax:[_endControl frameId] - 1];
    [_currentControl setMin:[_startControl frameId]];
    [_currentControl setMax:[_endControl frameId]];
    [_currentControl setFrameId:[_currentControl frameId]];
    [self updateRect];
}

- (void)updateCurrentFrame {
    SKKeyframe *lastFrame;
    for (SKKeyframe *keyframe in keyframes) {
        if ([keyframe frameId] == [_currentControl frameId]) {
            [_pose setSkeleton:[keyframe skeleton]];
            return;
        } else if ([keyframe frameId] > [_currentControl frameId]) {
            if (lastFrame) {
                float percent = FloatPercentBetween([keyframe frameId], [lastFrame frameId], [_currentControl frameId]);
                [_pose setSkeleton:AHSkeletonLerp([lastFrame skeleton], [keyframe skeleton], percent)];
                return;
            } else {
                [_pose setSkeleton:[keyframe skeleton]];
                return;
            }
        }
        lastFrame = keyframe;
    }
    [_pose setSkeleton:[lastFrame skeleton]];
}

- (void)updateRect {
    rect.size.width = [_endControl frameId] * 10.0f + 100.0f;
    self.frame = rect;
    
    // superview
    CGRect superRect = self.superview.frame;
    superRect.size.width = rect.size.width;
    self.superview.frame = superRect;
}

- (void)updateKeyframes {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"frameId" ascending:YES];
    [keyframes sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}

- (void)removeKeyframe {
    for (SKKeyframe *keyframe in keyframes) {
        if ([keyframe frameId] == [_currentControl frameId] && 
            [keyframes containsObject:keyframe]) {
            [keyframes removeObject:keyframe];
        }
    }
    [self updateKeyframes];
}


#pragma mark -
#pragma mark skeleton change


- (void)skeletonChanged {
    if ([self addKeyframe]) {
        return;
    }
    for (SKKeyframe *keyframe in keyframes) {
        if ([keyframe frameId] == [_currentControl frameId]) {
            [keyframe setSkeleton:[[self pose] skeleton]];
        }
    }
}


#pragma mark -
#pragma mark data


- (NSMutableDictionary *)dictionaryForSkeleton:(AHSkeleton)skeleton {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithFloat:skeleton.waist] forKey:@"waist"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.neck] forKey:@"neck"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.shoulderA] forKey:@"shoulderA"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.shoulderB] forKey:@"shoulderB"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.elbowA] forKey:@"elbowA"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.elbowB] forKey:@"elbowB"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.kneeA] forKey:@"kneeA"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.kneeB] forKey:@"kneeB"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.hipA] forKey:@"hipA"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.hipB] forKey:@"hipB"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.x] forKey:@"x"];
    [dict setObject:[NSNumber numberWithFloat:skeleton.y] forKey:@"y"];
    return dict;
}

- (AHSkeleton)skeletonForDictionary:(NSDictionary *)dict {
    AHSkeleton skeleton;
    skeleton.x = [[dict objectForKey:@"x"] floatValue];
    skeleton.y = [[dict objectForKey:@"y"] floatValue];
    
    skeleton.neck = [[dict objectForKey:@"neck"] floatValue];
    skeleton.waist = [[dict objectForKey:@"waist"] floatValue];
    
    skeleton.shoulderA = [[dict objectForKey:@"shoulderA"] floatValue];
    skeleton.shoulderB = [[dict objectForKey:@"shoulderB"] floatValue];
    
    skeleton.elbowA = [[dict objectForKey:@"elbowA"] floatValue];
    skeleton.elbowB = [[dict objectForKey:@"elbowB"] floatValue];
    
    skeleton.kneeA = [[dict objectForKey:@"kneeA"] floatValue];
    skeleton.kneeB = [[dict objectForKey:@"kneeB"] floatValue];
    
    skeleton.hipA = [[dict objectForKey:@"hipA"] floatValue];
    skeleton.hipB = [[dict objectForKey:@"hipB"] floatValue];
    return skeleton;
}

- (NSData *)keyframeData {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (SKKeyframe *keyframe in keyframes) {
        NSMutableDictionary *dict = [self dictionaryForSkeleton:[keyframe skeleton]];
        [dict setObject:[NSNumber numberWithInt:[keyframe frameId]] forKey:@"time"];
        [array addObject:dict];
    }
    NSError *error;
    return [[CJSONSerializer serializer] serializeArray:array error:&error];
}

- (void)setKeyframeData:(NSData *)data {
    NSError *error;
    NSArray *array = [[CJSONDeserializer deserializer] deserializeAsArray:data error:&error];
    if (!array) {
        NSLog(@"Error : %@", [error localizedDescription]);
        return;
    }
    
    for (NSDictionary *dict in array) {
        AHSkeleton skel = [self skeletonForDictionary:dict];
        
        SKKeyframe *keyframe = [[SKKeyframe alloc] init];
        [keyframe setMin:0];
        [keyframe setMax:KEYFRAME_MAX];
        [keyframe setFrameId:[[dict objectForKey:@"time"] intValue]];
        [self addSubview:keyframe positioned:NSWindowBelow relativeTo:nil];
        [keyframes addObject:keyframe];
        [keyframe setSkeleton:skel];
    }
    [self updateKeyframes];
    [self updateCurrentFrame];
}


#pragma mark -
#pragma mark copy paste



- (void)copy {
    AHSkeleton skeleton = [_pose skeleton];
    NSData *data = [NSData dataWithBytes:&skeleton length:sizeof(AHSkeleton)];
    
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    
    NSString *type = [NSString stringWithString:@"skel.anim"];
    NSArray *array = [NSArray arrayWithObject:type];
    [pb declareTypes:array owner:self];
    
    [pb setData:data forType:type];
}

- (void)paste {
    AHSkeleton skeleton;
    
    NSString *type = [NSString stringWithString:@"skel.anim"];
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    NSData *data = [pb dataForType:type];
    [data getBytes:&skeleton length:sizeof(AHSkeleton)];
    
    [_pose setSkeleton:skeleton];
    [self skeletonChanged];
}

- (void)cut {
    [self copy];
    [self removeKeyframe];
}


@end
