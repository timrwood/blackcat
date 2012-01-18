//
//  BCHeroPlaybackActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//



#import "AHMathUtils.h"
#import "AHPhysicsCircle.h"
#import "AHTimeManager.h"

#import "CJSONDeserializer.h"

#import "BCGlobalManager.h"
#import "BCHeroPlaybackActor.h"


@interface BCHeroPlaybackKeyframe : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) float time;

- (CGPoint)pointAtTime:(float)inTime fromLastKeyframe:(BCHeroPlaybackKeyframe *)frame;

@end

@implementation BCHeroPlaybackKeyframe

@synthesize position;
@synthesize time;

- (CGPoint)pointAtTime:(float)inTime fromLastKeyframe:(BCHeroPlaybackKeyframe *)frame {
    float percent = [AHMathUtils percentForFloat:inTime betweenFloat:[frame time] andFloat:time];
    //dlog(@"percent %F", percent);
    return [AHMathUtils percent:percent betweenPointA:[frame position] andPointB:position];
}

@end

@implementation BCHeroPlaybackActor


- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsCircle alloc] initFromRadius:0.6f andPosition:CGPointMake(0.0f, 0.0f)];
        [_body setStatic:NO];
        [_body setSensor:YES];
        [self addComponent:_body];
        
        // unpack
        NSError *error;
        NSArray *frames = [[CJSONDeserializer deserializer] deserializeAsArray:data error:&error];
        if (error) {
            dlog(@"error: %@", [error localizedDescription]);
        }
        _frames = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in frames) {
            //dlog(@"adding dict");
            float x = [[dict objectForKey:@"x"] floatValue];
            float y = [[dict objectForKey:@"y"] floatValue];
            float t = [[dict objectForKey:@"t"] floatValue];
            BCHeroPlaybackKeyframe *kf = [[BCHeroPlaybackKeyframe alloc] init];
            [kf setTime:t];
            [kf setPosition:CGPointMake(x, y)];
            [_frames addObject:kf];
        }
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    float time = [[AHTimeManager manager] worldTime];
    CGPoint pos;
    
    for (int i = _currentIndex; i < [_frames count]; i++) {
        if (i == 0) {
            continue;
        }
        BCHeroPlaybackKeyframe *currentKeyframe = (BCHeroPlaybackKeyframe *) [_frames objectAtIndex:i];
        BCHeroPlaybackKeyframe *lastKeyframe = (BCHeroPlaybackKeyframe *) [_frames objectAtIndex:i - 1];
        if ([currentKeyframe time] > time) {
            pos = [currentKeyframe pointAtTime:time fromLastKeyframe:lastKeyframe];
            _currentIndex = i;
            //dlog(@"time : %F position : %F %F", time, pos.x, pos.y);
            break;
        }
    }
    
    if (_body) {
        [_body setPosition:pos];
    }
}


@end
