//
//  AHSuperSystem.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


@protocol AHSuperSystemDelegate <NSObject>


- (void)updateBeforePhysics;
- (void)updateBeforeAnimation;
- (void)updateBeforeRender;
- (void)updateAfterEverything;


@end


@interface AHSuperSystem : NSObject {
@private;
    BOOL _isEnabledDebugDraw;
    BOOL _isEnabledRenderDraw;
    
    BOOL _isPaused;
    
    NSObject <AHSuperSystemDelegate> *_delegate;
}


#pragma mark -
#pragma mark singleton


+ (AHSuperSystem *)manager;


#pragma mark -
#pragma mark setup


- (void)setup;


#pragma mark -
#pragma mark teardown


- (void)enterBackground;
- (void)teardown;


#pragma mark -
#pragma mark delegate


- (void)setDelegate:(NSObject <AHSuperSystemDelegate> *)delegate;


#pragma mark -
#pragma mark cleanCache


- (void)cleanCache;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)draw;
- (void)setDebugDraw:(BOOL)enableDebugDraw;
- (void)setRenderDraw:(BOOL)enableRenderDraw;


#pragma mark -
#pragma mark pause


- (void)pause;
- (void)resume;


@end
