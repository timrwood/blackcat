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
        _baseEffect = [[GLKBaseEffect alloc] init];
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!_eaglContext) {
            dlog(@"Failed to create EAGLContext");
        }
        
        [EAGLContext setCurrentContext:_eaglContext];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark context


- (EAGLContext *)context {
    return _eaglContext;
}


#pragma mark -
#pragma mark effect


- (void)setTexture0:(GLuint)tex {
    if (tex != _currentTex0 || _baseEffect.texture2d0.enabled == NO) {
        //dlog(@"Activating texture %i", tex);
        _currentTex0 = tex;
        _baseEffect.useConstantColor = NO;
        _baseEffect.texture2d0.enabled = YES;
        _baseEffect.texture2d0.envMode = GLKTextureEnvModeReplace;
        _baseEffect.texture2d0.target = GLKTextureTarget2D;
        _baseEffect.texture2d0.name = _currentTex0;
        [_baseEffect prepareToDraw];
    }
}

- (void)setCameraMatrix:(GLKMatrix4)matrix {
    _baseEffect.transform.modelviewMatrix = matrix;
    [_baseEffect prepareToDraw];
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
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
    glClearColor(0.65f, 0.75f, 0.85f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_camera prepareToDrawWorld];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    for (AHGraphicsLayer *layer in _layers) {
        [layer draw];
    }
}


#pragma mark -
#pragma mark color


- (void)setDrawColor:(GLKVector4)color {
    if (!GLKVector4AllEqualToVector4(color, _currentColor)) {
        _currentColor = color;
        _baseEffect.useConstantColor = YES;
        _baseEffect.texture2d0.enabled = NO;
        _baseEffect.constantColor = _currentColor;
        [_baseEffect prepareToDraw];
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



