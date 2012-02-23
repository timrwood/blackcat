//
//  AHParticleRenderer.h
//  BlackCat
//
//  Created by Tim Wood on 2/22/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"


typedef struct _AHParticle {
	GLKVector3 position;
	GLKVector3 rotation;
	GLKVector3 linearVelocity;
	GLKVector3 angularVelocity;
	float scale;
	float lifetimeLeft;
	float lifetime;
	float padding;
} AHParticle;

typedef struct _AHParticleEmitterConfig {
	GLKVector3 position;
	GLKVector3 positionVariance;
    
	GLKVector3 rotation;
	GLKVector3 rotationVariance;
    
	GLKVector3 linearVelocity;
	GLKVector3 linearVelocityVariance;
    
	GLKVector3 angularVelocity;
	GLKVector3 angularVelocityVariance;
    
	GLKVector3 gravity;
    
	float scale;
	float scaleVariance;
    
	float lifetime;
	float lifetimeVariance;
    
    float particlesPerSecond;
    
    BOOL hasLifetime;
    float emitterLifetimeLeft;
} AHParticleEmitterConfig;


@class AHParticleRenderer;


@interface AHParticleEmitter : AHActorComponent {
@private;
    AHParticleEmitterConfig _config;
    
    int _max;
    int _count;
    int _index;
    float _secondsSinceLastParticle;
    
    AHParticleRenderer *_renderer;
    AHParticle *_particles;
    
    BOOL _isActive;
}


#pragma mark -
#pragma mark init


- (id)initWithMax:(int)max;


#pragma mark -
#pragma mark config


- (void)setConfig:(AHParticleEmitterConfig)config;
- (AHParticleEmitterConfig)config;


#pragma mark -
#pragma mark renderer


- (void)setRenderer:(AHParticleRenderer *)renderer;


#pragma mark -
#pragma mark add


- (BOOL)addParticle;
- (void)initParticle:(AHParticle *)particle;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark stop


- (void)start;
- (void)stop;


#pragma mark -
#pragma mark draw


- (void)draw;


@end
