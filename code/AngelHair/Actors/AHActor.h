//
//  AHActor.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//



@interface AHActor : NSObject {
@private
    NSMutableArray *components;
}


#pragma mark -
#pragma mark components


- (void)addComponent:(<AHComponent> *)component;
- (void)removeComponent:(<AHComponent> *)component;
- (void)removeAllComponents;


#pragma mark -
#pragma mark update


- (void)updateBeforePhysics;
- (void)updateBeforeAnimation;
- (void)updateBeforeRender;


#pragma mark -
#pragma mark destroy


- (void)cleanupBeforeDestruction;
- (void)destroy;


@end
