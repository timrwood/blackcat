//
//  BCCrateActor.mm
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define CRATE_SIZE 0.5f


#import "BCCrateActor.h"
#import "AHPhysicsRect.h"


@implementation BCCrateActor


#pragma mark -
#pragma mark init


- (id)initAtPosition:(CGPoint)position {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsRect alloc] initFromSize:CGSizeMake(CRATE_SIZE, CRATE_SIZE) andPosition:position];
        [_body setStatic:NO];
        [self addComponent:_body];
    }
    return self;
}


#pragma mark -
#pragma mark static vars


+ (float)size {
    return CRATE_SIZE;
}


#pragma mark -
#pragma mark update


- (void)updateBeforeAnimation {
    
}


@end
