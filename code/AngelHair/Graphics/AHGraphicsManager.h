//
//  AHGraphicsManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <GLKit/GLKit.h>
#import "AHSubSystem.h"
#import "AHGraphicsCamera.h"


@interface AHGraphicsManager : NSObject <AHSubSystem> {
@private;
    EAGLContext *_eaglContext;
    GLKBaseEffect *_baseEffect;
}


#pragma mark -
#pragma mark singleton


+ (AHGraphicsManager *)manager;
+ (AHGraphicsCamera *)camera;


#pragma mark -
#pragma mark vars


- (EAGLContext *)context;
- (GLKBaseEffect *)effect;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)draw;


#pragma mark -
#pragma mark color


- (void)setDrawColor:(GLKVector4)color;


@end
