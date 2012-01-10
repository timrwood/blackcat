//
//  AHTextureManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import <GLKit/GLKit.h>
#import "AHSubSystem.h"
#import "AHTextureInfo.h"


@interface AHTextureManager : NSObject <AHSubSystem> {
    NSMutableDictionary *textures;
    GLKTextureLoader *loader;
    
    int unloadedTextures;
}


#pragma mark -
#pragma mark singleton


+ (AHTextureManager *)manager;


#pragma mark -
#pragma mark cleanCache


- (void)cleanCache;


#pragma mark -
#pragma mark textures


- (void)addTexture:(AHTextureInfo *)texture forKey:(NSString *)key;
- (void)removeTextureForKey:(NSString *)key;
- (void)removeAllTextures;
- (void)removeAllUnusedTextures;
- (AHTextureInfo *)textureForKey:(NSString *)key;


@end