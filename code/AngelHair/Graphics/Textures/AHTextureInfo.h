//
//  AHTextureInfo.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <GLKit/GLKit.h>


@interface AHTextureInfo : NSObject {
    int deps;
}


#pragma mark -
#pragma mark vars


@property (nonatomic, strong) GLKTextureInfo *info;


#pragma mark -
#pragma mark dependants


- (void)addDependant;
- (void)removeDependant;
- (int)dependants;


#pragma mark -
#pragma mark name


- (float)name;


@end
