//
//  AHTextureManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsManager.h"
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
        _textures = [[NSMutableDictionary alloc] init];
        _loader = [[GLKTextureLoader alloc] init];
        _unloadedTextures = 0;
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
    [_textures setObject:texture forKey:key];
}

- (void)removeTextureForKey:(NSString *)key {
    [_textures removeObjectForKey:key];
}

- (void)removeAllTextures {
    [_textures removeAllObjects];
}

- (void)removeAllUnusedTextures {
    for (NSString* key in _textures) {
        AHTextureInfo *texture = (AHTextureInfo *)[_textures objectForKey:key];
        if ([texture dependants] < 1) {
            [self removeTextureForKey:key];
        }
    }
}

- (AHTextureInfo *)textureForKey:(NSString *)key {
    AHTextureInfo *texture = [_textures objectForKey:key];
    
    if (!texture) {
        _unloadedTextures ++;
        texture = [[AHTextureInfo alloc] init];
        [_textures setObject:texture forKey:key];
        
        // async texture loading
        
        NSError *error;
        [texture setInfo:[GLKTextureLoader textureWithContentsOfFile:[[AHFileManager manager] pathToResourceFile:key] options:NULL error:&error]];
        
        if (![texture info]) {
            dlog(@"Error loading texture : %@ - %@", key, [error localizedDescription]);
            dlog(@"Looking for texture in : %@", [[AHFileManager manager] pathToResourceFile:key]);
        }
        /*
        [_loader textureWithContentsOfFile:[[AHFileManager manager] pathToResourceFile:key]
                                  options:NULL
                                    queue:NULL
                        completionHandler:^(GLKTextureInfo *textureInfo, NSError *outError) {
                            _unloadedTextures--;
                            [texture setInfo:textureInfo];
                            if (!textureInfo) {
                                dlog(@"Error loading texture : %@ - %@", key, [outError localizedDescription]);
                                dlog(@"Looking for texture in : %@", [[AHFileManager manager] pathToResourceFile:key]);
                            }
                        }];
         */
    }
    
    [texture addDependant];
    
    return texture;
}


#pragma mark -
#pragma mark activate


- (void)activateTexture:(AHTextureInfo *)texture {
    if (!texture) {
        return;
    }
    return;
    if ([[texture info] name] != _currentTexture) {
        _currentTexture = [[texture info] name];
        [[[AHGraphicsManager manager] effect] setUseConstantColor:NO];
        [[[[AHGraphicsManager manager] effect] texture2d0] setEnvMode:GLKTextureEnvModeReplace];
        [[[[AHGraphicsManager manager] effect] texture2d0] setTarget:GLKTextureTarget2D];
        [[[[AHGraphicsManager manager] effect] texture2d0] setName:_currentTexture];
        //[[[AHGraphicsManager manager] effect] prepareToDraw];
    }
}


@end

