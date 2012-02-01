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
}


#pragma mark -
#pragma mark init


- (id)initWithType:(int)newId;
- (id)initWithType:(int)newId andFloat:(float)newFloat;
- (id)initWithType:(int)newId andPoint:(GLKVector2)point;


#pragma mark -
#pragma mark getters


- (int)type;
- (float)valueAsFloat;
- (GLKVector2)valueAsPoint;


@end
