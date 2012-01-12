//
//  BCBuildingActor.m
//  BlackCat
//
//  Created by Tim Wood on 1/11/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsRect.h"

#import "BCBuildingActor.h"


@implementation BCBuildingActor


#pragma mark -
#pragma mark init


- (id)initFromSize:(CGPoint)size andPosition:(CGPoint)position {
    self = [super init];
    if (self) {
        _body = [[AHPhysicsRect alloc] initFromSize:size andPosition:position];
        [_body setStatic:YES];
        [self addComponent:_body];
    }
    return self;
}


@end
