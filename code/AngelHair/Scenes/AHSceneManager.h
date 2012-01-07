//
//  AHSceneManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSubSystem.h"


@interface AHSceneManager : NSObject <AHSubSystem> {
@private
    
}


#pragma mark -
#pragma mark singleton


+ (AHSceneManager *)manager;


#pragma mark -
#pragma mark update


- (void)update;


@end
