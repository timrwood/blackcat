//
//  AHParticleManager.h
//  BlackCat
//
//  Created by Tim Wood on 2/22/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSubSystem.h"


@class AHParticleEmitter;


@interface AHParticleManager : NSObject <AHSubSystem> {
@private;
    NSMutableArray *_emitters;
}


#pragma mark -
#pragma mark singleton


+ (AHParticleManager *)manager;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)draw;


#pragma mark -
#pragma mark emitters


- (void)addEmitter:(AHParticleEmitter *)emitter;
- (void)removeEmitter:(AHParticleEmitter *)emitter;
- (void)removeAllEmitters;


@end
