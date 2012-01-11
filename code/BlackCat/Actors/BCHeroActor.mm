//
//  BCHeroActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/10/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCHeroActor.h"
#import "AHPhysicsCircle.h"


@implementation BCHeroActor


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsCircle alloc] initFromRadius:1.0f andPosition:CGPointMake(0.0f, 0.0f)];
        [_body setStatic:NO];
        [self addComponent:_body];
    }
    return self;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    [_body setLinearVelocity:CGPointMake(1.0f, 0.0f)];
    //CGPoint pos = [_body position];
    //dlog("Position: x %F y%F", pos.x, pos.y);
}


@end
