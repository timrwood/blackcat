//
//  AHParticleRenderer.h
//  BlackCat
//
//  Created by Tim Wood on 2/22/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHParticleEmitter.h"
#import "AHActorComponent.h"


@interface AHParticleRenderer : AHActorComponent {
@protected;
    int count;
}


#pragma mark -
#pragma mark size


- (void)setMax:(int)max;
- (void)setCount:(int)newCount;


#pragma mark -
#pragma mark update


- (void)updateParticle:(AHParticle *)particle atIndex:(int)index;


#pragma mark -
#pragma mark draw


- (void)draw;


@end
