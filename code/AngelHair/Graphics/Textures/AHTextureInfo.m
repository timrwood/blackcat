//
//  AHTextureInfo.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHTextureInfo.h"


@implementation AHTextureInfo


#pragma mark -
#pragma mark vars


@synthesize info;


#pragma mark -
#pragma mark dependants


- (void)addDependant {
    deps++;
}

- (void)removeDependant {
    deps--;
}

- (int)dependants {
    return deps;
}


@end
