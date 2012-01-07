//
//  BCPhysics.m
//  BlackCat
//
//  Created by Tim Wood on 11/28/11.
//  Copyright Infinite Beta Games 2011. All rights reserved.
//


#import "AHPhysicsManager.h"


static AHPhysicsManager *_manager = nil;


@implementation AHPhysicsManager


#pragma mark -
#pragma mark singleton


+ (AHPhysicsManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
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
    
}


#pragma mark -
#pragma mark setup


- (void)setup {
    world = new b2World(b2Vec2(0.0f, 10.0f));
}


#pragma mark -
#pragma mark update


- (void)update {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


#pragma mark -
#pragma mark bodies


- (b2Body *)addBodyFromDef:(b2BodyDef *)bodyDef {
    return world->CreateBody(bodyDef);
}


@end