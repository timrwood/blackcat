//
//  AHActorMessage.h
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


@interface AHActorMessage : NSObject {
@private;
    int _type;
    float _a;
    float _b;
    float _c;
    float _d;
}


#pragma mark -
#pragma mark init


- (id)initWithType:(int)type;
- (id)initWithType:(int)type andFloat:(float)newFloat;
- (id)initWithType:(int)type andFloat:(float)newFloat andFloat:(float)newFloat;
- (id)initWithType:(int)type andPoint:(GLKVector2)point;
- (id)initWithType:(int)type andPoint:(GLKVector2)point andFloat:(float)newFloat;
- (id)initWithType:(int)type andPoint:(GLKVector2)point andPoint:(GLKVector2)point;
- (id)initWithType:(int)type and4Floats:(float *)floats;


#pragma mark -
#pragma mark getters


- (int)type;
- (float)firstFloat;
- (float)secondFloat;
- (float)thirdFloat;
- (float)fourthFloat;
- (GLKVector2)firstPoint;
- (GLKVector2)secondPoint;


@end
