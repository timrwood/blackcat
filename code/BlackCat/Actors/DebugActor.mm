//
//  DebugActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "DebugActor.h"
#import "AHPhysicsRect.h"


@implementation DebugActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsRect alloc] initFromSize:CGPointMake(0.5f, 0.1f) 
                                        andRotation:0.0f 
                                        andPosition:CGPointMake(0.0f, 0.0f)];
        [_body setStatic:NO];
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    CGPoint pos = [_body position];
    //dlog("Position: x %F y%F", pos.x, pos.y);
}


@end
