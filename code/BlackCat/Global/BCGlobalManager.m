//
//  BCGlobalManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCGlobalManager.h"


static BCGlobalManager *_manager = nil;


@implementation BCGlobalManager


#pragma mark -
#pragma mark singleton


+ (BCGlobalManager *)manager {
    if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark vars


@synthesize heroSpeed;
@synthesize heroPosition;

@synthesize buildingHeight;


@end
