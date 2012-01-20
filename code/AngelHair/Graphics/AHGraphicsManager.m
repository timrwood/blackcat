//
//  AHGraphicsManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsObject.h"
#import "AHGraphicsLayer.h"
#import "AHGraphicsManager.h"
#import "AHPhysicsManager.h"


static AHGraphicsManager *_manager = nil;
static AHGraphicsCamera *_camera = nil;


@implementation AHGraphicsManager


#pragma mark -
#pragma mark singleton


+ (AHGraphicsManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    if (!_camera) {
        _camera = [[AHGraphicsCamera alloc] init];
	}
    
	return _manager;
}

+ (AHGraphicsCamera *)camera {
    if (!_camera) {
        _camera = [[AHGraphicsCamera alloc] init];
	}
    
    return _camera;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _layers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark vars


- (EAGLContext *)context {
    return _eaglContext;
}

- (GLKBaseEffect *)effect {
    return _baseEffect;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_eaglContext) {
        dlog(@"Failed to create EAGLContext");
    }
    
    [EAGLContext setCurrentContext:_eaglContext];
    
    _baseEffect = [[GLKBaseEffect alloc] init];
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    [EAGLContext setCurrentContext:_eaglContext];
    _baseEffect = nil;
}


#pragma mark -
#pragma mark update


- (void)update {
    
}


#pragma mark -
#pragma mark draw


- (void)draw {
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_camera prepareToDrawWorld];
    
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	glEnable(GL_TEXTURE_2D);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    for (AHGraphicsLayer *layer in _layers) {
        [layer draw];
    }
    
	glDisable(GL_TEXTURE_2D);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}


#pragma mark -
#pragma mark color


- (void)setDrawColor:(GLKVector4)color {
    if (!GLKVector4AllEqualToVector4(color, currentColor)) {
        currentColor = color;
        _baseEffect.useConstantColor = YES;
        _baseEffect.constantColor = color;
        //[_baseEffect prepareToDraw];
    }
}


#pragma mark -
#pragma mark layers


- (void)addLayer:(AHGraphicsLayer *)layer atIndex:(int)i {
    if (![_layers containsObject:layer]) {
        [_layers addObject:layer];
    }
}

- (void)removeLayer:(AHGraphicsLayer *)layer {
    if ([_layers containsObject:layer]) {
        [_layers removeObject:layer];
    }
}

- (void)removeAllUnusedLayers {
    int skipped = 0;
    while ([_layers count] > skipped) {
        AHGraphicsLayer *layer = (AHGraphicsLayer *)[_layers objectAtIndex:skipped];
        if ([layer hasObjects]) {
            skipped ++;
        } else {
            [self removeLayer:layer];
        }
    }
}

- (void)removeAllLayers {
    while ([_layers count] > 0) {
        [self removeLayer:(AHGraphicsLayer *)[_layers objectAtIndex:0]];
    }
}


#pragma mark -
#pragma mark layers


- (void)addObject:(AHGraphicsObject *)object toLayerIndex:(int)i {
    //dlog(@"object");
    
    if (i >= [_layers count] || ![_layers objectAtIndex:i]) {
        [self addLayer:[[AHGraphicsLayer alloc] init] atIndex:i];
    }
    
    AHGraphicsLayer *layer = [_layers objectAtIndex:i];
    
    [object removeFromParentLayer];
    [layer addObject:object];
}


@end



