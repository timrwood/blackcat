//
//  AHParticleManager.m
//  BlackCat
//
//  Created by Tim Wood on 2/22/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsManager.h"
#import "AHParticleEmitter.h"
#import "AHParticleManager.h"


static AHParticleManager *_manager = nil;


@implementation AHParticleManager


#pragma mark -
#pragma mark singleton


+ (AHParticleManager *)manager {
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
        _emitters = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


#pragma mark -
#pragma mark update


- (void)update {
    for (AHParticleEmitter *emitter in _emitters) {
        [emitter update];
    }
}


#pragma mark -
#pragma mark draw


- (void)draw {
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [[AHGraphicsManager camera] prepareToDrawWorld];
    
    for (AHParticleEmitter *emitter in _emitters) {
        [emitter draw];
    }
}


#pragma mark -
#pragma mark emitters


- (void)addEmitter:(AHParticleEmitter *)emitter {
    if (![_emitters containsObject:emitter]) {
        [_emitters addObject:emitter];
    }
    
    dlog(@"add emitter");
}

- (void)removeEmitter:(AHParticleEmitter *)emitter {
    if ([_emitters containsObject:emitter]) {
        [_emitters removeObject:emitter];
    }
}

- (void)removeAllEmitters {
    while ([_emitters count] > 0) {
        [self removeEmitter:(AHParticleEmitter *)[_emitters objectAtIndex:0]];
    }
}


@end



