//
//  AHScreenManager.h
//  BlackCat
//
//  Created by Tim Wood on 2/7/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface AHScreenManager : NSObject {
@private;
    CGRect _screen;
}


#pragma mark -
#pragma mark singleton


+ (AHScreenManager *)manager;


#pragma mark -
#pragma mark screen rect


- (CGRect)screenRect;
- (float)screenHeight;
- (float)screenWidth;


@end
