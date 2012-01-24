//
//  BCGlobalManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/12/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


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


@end
