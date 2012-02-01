//
//  AHGraphicsLayer.h
//  BlackCat
//
//  Created by Tim Wood on 1/20/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


@class AHGraphicsObject;


@interface AHGraphicsLayer : NSObject {
@private;
    NSMutableArray *_objects;

    GLuint _currentTexture;
}


#pragma mark -
#pragma mark objects


- (BOOL)hasObjects;
- (void)addObject:(AHGraphicsObject *)object;
- (void)removeObject:(AHGraphicsObject *)object;
- (void)removeAllObjects;


#pragma mark -
#pragma mark draw


- (void)draw;


#pragma mark -
#pragma mark update


- (void)update;


@end
