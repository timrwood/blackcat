//
//  AHLightManager.h
//  BlackCat
//
//  Created by Tim Wood on 2/15/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


@interface AHLightManager : NSObject {
@private;
    GLKVector3 *_lightPosition;
}


#pragma mark -
#pragma mark singleton


+ (AHLightManager *)manager;


@end
