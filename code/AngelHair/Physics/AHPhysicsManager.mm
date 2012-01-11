//
//  BCPhysics.m
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


#import "AHPhysicsManager.h"
#import "AHPhysicsManagerCPP.h"


static AHPhysicsManager *_manager = nil;
static AHPhysicsManagerCPP *_cppManager = nil;


@implementation AHPhysicsManager


#pragma mark -
#pragma mark singleton


+ (AHPhysicsManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    if (!_cppManager) {
        _cppManager = [[AHPhysicsManagerCPP alloc] init];
	}
    
	return _manager;
}

+ (AHPhysicsManagerCPP *)cppManager {
    if (!_cppManager) {
        _cppManager = [[AHPhysicsManagerCPP alloc] init];
	}
    
	return _cppManager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    _cppManager = NULL;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [_cppManager setup];
}


#pragma mark -
#pragma mark update


- (void)update {
    [_cppManager update];
}


#pragma mark -
#pragma mark draw


- (void)drawDebug {
    [_cppManager drawDebug];
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    [_cppManager teardown];
}


@end