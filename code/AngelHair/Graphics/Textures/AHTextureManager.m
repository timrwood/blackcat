//
//  AHTextureManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHTextureManager.h"
#import "AHFileManager.h"


static AHTextureManager *_manager = nil;


@implementation AHTextureManager


#pragma mark -
#pragma mark singleton


+ (AHTextureManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        textures = [[NSMutableDictionary alloc] init];
        loader = [[GLKTextureLoader alloc] init];
        unloadedTextures = 0;
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark cleanCache


- (void)cleanCache {
    [self removeAllUnusedTextures];
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    [self removeAllTextures];
}


#pragma mark -
#pragma mark textures

             
- (void)addTexture:(AHTextureInfo *)texture forKey:(NSString *)key {
    [textures setObject:texture forKey:key];
}

- (void)removeTextureForKey:(NSString *)key {
    [textures removeObjectForKey:key];
}

- (void)removeAllTextures {
    [textures removeAllObjects];
}

- (void)removeAllUnusedTextures {
    for (NSString* key in textures) {
        AHTextureInfo *texture = (AHTextureInfo *)[textures objectForKey:key];
        if ([texture dependants] < 1) {
            [self removeTextureForKey:key];
        }
    }
}

- (AHTextureInfo *)textureForKey:(NSString *)key {
    AHTextureInfo *texture = [textures objectForKey:key];
    
    if (!texture) {
        unloadedTextures ++;
        texture = [[AHTextureInfo alloc] init];
        [textures setObject:texture forKey:key];
        
        // async texture loading
        [loader textureWithContentsOfFile:[[AHFileManager manager] pathToResourceFile:key]
                                            options:NULL
                                              queue:NULL
                                  completionHandler:^(GLKTextureInfo *textureInfo, NSError *outError) {
                                      unloadedTextures--;
                                      [texture setInfo:textureInfo];
                                  }];
    }
    
    [texture addDependant];
    
    return texture;
}


@end

