//
//  AHParticleRenderer.m
//  BlackCat
//
//  Created by Tim Wood on 2/22/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#define MAX_PARTICLES 100


#import "AHTimeManager.h"
#import "AHMathUtils.h"
#import "AHParticleEmitter.h"
#import "AHParticleRenderer.h"
#import "AHParticleManager.h"


@implementation AHParticleEmitter


#pragma mark -
#pragma mark init


- (id)init {
    return [self initWithMax:MAX_PARTICLES];
}

- (id)initWithMax:(int)max {
    self = [super init];
    if (self) {
        _max = max;
        _particles = (AHParticle *) malloc(sizeof(AHParticle) * _max);
        _count = 0;
        _isActive = YES;
    }
    return self;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [[AHParticleManager manager] addEmitter:self];
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    [[AHParticleManager manager] removeEmitter:self];
    if (_renderer) {
        [_renderer cleanupAfterRemoval];
    }
    _renderer = nil;
}


#pragma mark -
#pragma mark config


- (void)setConfig:(AHParticleEmitterConfig)config {
    _config = config;
}

- (AHParticleEmitterConfig)config {
    return _config;
}


#pragma mark -
#pragma mark renderer


- (void)setRenderer:(AHParticleRenderer *)renderer {
    _renderer = renderer;
    [_renderer setMax:_max];
}


#pragma mark -
#pragma mark add


- (BOOL)addParticle {
	// If we have already reached the maximum number of particles then do nothing
	if (_count == _max) {
		return NO;
    }
	
	// Take the next particle out of the particle pool we have created and initialize it
	[self initParticle:&_particles[_count]];
	
	// Increment the particle count
	_count++;
	
	// Return YES to show that a particle has been created
	return YES;
}

- (void)initParticle:(AHParticle *)particle {
    GLKVector3 variance;
    
    // position
    variance = GLKVector3Multiply(_config.positionVariance, GLKVector3RandomBetweenNegativeAndPositive1());
    particle->position = GLKVector3Add(_config.position, variance);
	
    // linear velocity
    variance = GLKVector3Multiply(_config.linearVelocityVariance, GLKVector3RandomBetweenNegativeAndPositive1());
    particle->linearVelocity = GLKVector3Add(_config.linearVelocity, variance);
	
    // rotation
    variance = GLKVector3Multiply(_config.rotationVariance, GLKVector3RandomBetweenNegativeAndPositive1());
    particle->rotation = GLKVector3Add(_config.rotation, variance);
    
    // angular velocity
    variance = GLKVector3Multiply(_config.angularVelocityVariance, GLKVector3RandomBetweenNegativeAndPositive1());
    particle->angularVelocity = GLKVector3Add(_config.angularVelocity, variance);
	
	// Calculate the particles life span using the life span and variance passed in
	particle->lifetime = _config.lifetime + _config.lifetimeVariance * FloatRandomBetweenNegativeAndPositive1();
    particle->lifetimeLeft = particle->lifetime;
}


#pragma mark -
#pragma mark update


- (void)update {
    float time = [[AHTimeManager manager] worldSecondsPerFrame];
    
    // if active, emit particles
	if (_isActive && _config.particlesPerSecond > 0.0f) {
		float secondsPerParticle = 1.0f / _config.particlesPerSecond;
        _secondsSinceLastParticle += time;
		while (_count < _max && _secondsSinceLastParticle > secondsPerParticle) {
			[self addParticle];
			_secondsSinceLastParticle -= secondsPerParticle;
		}
		
        // check lifetime
		_config.emitterLifetimeLeft -= time;
		if (_config.hasLifetime && _config.emitterLifetimeLeft < 0.0f) {
			[self stop];
        }
	}
    
    _index = 0;
    
    GLKVector3 gravity = GLKVector3MultiplyScalar(_config.gravity, time);
    
	// Loop through all the particles updating their location and color
	while (_index < _count) {
		
		// Get the particle for the current particle index
		AHParticle *currentParticle = &_particles[_index];
		
		// If the current particle is alive then update it
		if (currentParticle->lifetimeLeft > 0.0f) {
			
			// Calculate the new direction based on gravity
			currentParticle->linearVelocity = GLKVector3Add(currentParticle->linearVelocity, gravity);
			currentParticle->position = GLKVector3Add(currentParticle->position, 
                                                     GLKVector3MultiplyScalar(currentParticle->linearVelocity, 
                                                                              time));
            
			currentParticle->rotation = GLKVector3Add(currentParticle->rotation, currentParticle->angularVelocity);
			
			// Reduce the life span of the particle
			currentParticle->lifetimeLeft -= time;
            
            if (_renderer) {
                [_renderer updateParticle:currentParticle atIndex:_index];
            }
			_index++;
		} else {
			if (_index != _count - 1) {
				_particles[_index] = _particles[_count - 1];
            }
			_count--;
		}
	}
    [_renderer setCount:_count];
}


#pragma mark -
#pragma mark stop


- (void)start {
    _isActive = YES;
}

- (void)stop {
    _isActive = NO;
}


#pragma mark -
#pragma mark draw


- (void)draw {
    if (_renderer) {
        [_renderer draw];
    }
}


@end
