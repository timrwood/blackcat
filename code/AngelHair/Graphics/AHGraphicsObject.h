//
//  AHGraphicsObject.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActorComponent.h"
#import "AHTextureInfo.h"


@interface AHGraphicsObject : AHActorComponent {
@protected;
    CGPoint *vertices;
    CGPoint *textures;
    
    int count;
    
    AHTextureInfo *texture;
}


#pragma mark -
#pragma mark vertices


- (void)setVertexCount:(int)newCount;


#pragma mark -
#pragma mark textures


- (void)setTextureKey:(NSString *)key;
- (GLuint)textureName;


@end
