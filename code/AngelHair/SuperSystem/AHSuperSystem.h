//
//  AHSuperSystem.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


@interface AHSuperSystem : NSObject {
@private;

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
#pragma mark cleanCache


- (void)cleanCache;


#pragma mark -
#pragma mark update


- (void)update;


#pragma mark -
#pragma mark draw


- (void)draw;


@end