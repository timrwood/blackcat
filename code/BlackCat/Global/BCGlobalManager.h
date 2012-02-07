//
//  BCGlobalManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "BCGlobalTypes.h"
#import <Foundation/Foundation.h>


@interface BCGlobalManager : NSObject


#pragma mark -
#pragma mark singleton


+ (BCGlobalManager *)manager;


#pragma mark -
#pragma mark vars


@property (nonatomic) float heroSpeed;
@property (nonatomic) GLKVector2 heroPosition;

@property (nonatomic) float buildingHeight;

@property (nonatomic) BCHeroTypes heroType;


@end
