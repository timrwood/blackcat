//
//  AHGraphicsObject.m
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHTextureManager.h"
#import "AHShaderManager.h"
#import "AHGraphicsManager.h"
#import "AHGraphicsLayer.h"
#import "AHGraphicsObject.h"
#import "AHTextureManager.h"


@implementation AHGraphicsObject


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        _drawType = GL_TRIANGLE_STRIP;
        _canBeBuffered = YES;
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark cache


- (void)doNotBuffer {
    _canBeBuffered = NO;
}

- (void)buffer {
    if (!_canBeBuffered) {
        return;
    }
    glGenBuffers(1, &_bufferId);
    glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    glBufferData(GL_ARRAY_BUFFER, _count * sizeof(GLKVector3), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_arrayId);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _arrayId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    _isBuffered = YES;
}


#pragma mark -
#pragma mark layer


- (void)setHudLayer:(BOOL)isForHud {
    _isForHud = isForHud;
}

- (void)setLayerIndex:(int)i {
    _layerIndex = i;
}

- (void)setLayer:(AHGraphicsLayer *)layer {
    _layer = layer;
}

- (void)removeFromParentLayer {
    if (_layer) {
        [_layer removeObject:self];
        _layer = nil;
    }
}


#pragma mark -
#pragma mark setup


- (void)setup {
    if (_isForHud) {
        [[AHGraphicsManager manager] addObjectToHudLayer:self];
    } else {
        [[AHGraphicsManager manager] addObject:self toLayerIndex:_layerIndex];
    }
    [self calculateTangentAndBinormals];
    //[self buffer];
}


#pragma mark -
#pragma mark vertices


- (void)setVertexCount:(int)newCount {
    if (_count != newCount) {
        if (vertices) {
            free(vertices);
        }
        if (textures) {
            free(textures);
        }
        if (normals) {
            free(normals);
        }
        if (tangents) {
            free(tangents);
        }
        if (binormals) {
            free(binormals);
        }
    }
    _count = newCount;
    self->vertices = (GLKVector3 *) malloc(sizeof(GLKVector3) * _count);
    self->textures = (GLKVector2 *) malloc(sizeof(GLKVector2) * _count);
    self->normals = (GLKVector3 *) malloc(sizeof(GLKVector3) * _count);
    self->binormals = (GLKVector3 *) malloc(sizeof(GLKVector3) * _count);
    self->tangents = (GLKVector3 *) malloc(sizeof(GLKVector3) * _count);
}

- (void)setIndexCount:(int)newCount {
    if (_indexCount != newCount) {
        if (indices) {
            free(indices);
        }
    }
    _indexCount = newCount;
    self->indices = (GLubyte *) malloc(sizeof(GLubyte) * _indexCount);
}

- (int)vertexCount {
    return _count;
}

- (void)calculateTangentAndBinormals {
    for (int i = 0; i < _indexCount; i += 3) {
        // indices
        int i1 = indices[i];
        int i2 = indices[i + 1];
        int i3 = indices[i + 2];
        
        // positions
        GLKVector3 p1 = vertices[i1];
        GLKVector3 p2 = vertices[i2];
        GLKVector3 p3 = vertices[i3];
        
        // textures
        GLKVector2 t1 = textures[i1];
        GLKVector2 t2 = textures[i2];
        GLKVector2 t3 = textures[i3];
        
        // texture vectors
        GLKVector2 tv1 = GLKVector2Subtract(t2, t1);
        GLKVector2 tv2 = GLKVector2Subtract(t3, t1);
        
        // position vectors
        GLKVector3 pv1 = GLKVector3Subtract(p2, p1);
        GLKVector3 pv2 = GLKVector3Subtract(p3, p1);
        
        /*float tmp = 1.0f;
        float r = tv1.x * tv2.y - tv2.x - tv1.y;
        
		if (fabsf(r) > 0.0001f) {
			tmp = 1.0f / r;
		}*/
        
        GLKVector3 normal = GLKVector3Normalize(GLKVector3CrossProduct(pv1, pv2));
        
        // set normals
        normals[i1] = normal;
        normals[i2] = normal;
        normals[i3] = normal;
        
        GLKVector3 tangent;
        tangent.x = (tv2.t * pv1.x - tv1.t * pv2.x);
		tangent.y = (tv2.t * pv1.y - tv1.t * pv2.y);
		tangent.z = (tv2.t * pv1.z - tv1.t * pv2.z);
        tangent = GLKVector3Normalize(tangent);
        
		//tangent = GLKVector3MultiplyScalar(tangent, tmp);
        
        GLKVector3 binormal;
		binormal.x = (tv1.s * pv2.x - tv2.s * pv1.x);
		binormal.y = (tv1.s * pv2.y - tv2.s * pv1.y);
		binormal.z = (tv1.s * pv2.z - tv2.s * pv1.z);
        binormal = GLKVector3Normalize(binormal);
        
        binormals[i1] = binormal;
        binormals[i2] = binormal;
        binormals[i3] = binormal;
        
        tangents[i1] = tangent;
        tangents[i2] = tangent;
        tangents[i3] = tangent;
    }
}

- (void)drawNormals {
    for (int i = 0; i < _indexCount; i += 3) {
        // indices
        int i1 = indices[i];
        int i2 = indices[i + 1];
        int i3 = indices[i + 2];
        
        // positions
        GLKVector3 p1 = vertices[i1];
        GLKVector3 p2 = vertices[i2];
        GLKVector3 p3 = vertices[i3];
        
        GLKVector3 pc = GLKVector3DivideScalar(GLKVector3Add(GLKVector3Add(p1, p2), p3), 3.0f);
        GLKVector3 pn = GLKVector3Add(pc, normals[i1]);
        GLKVector3 pb = GLKVector3Add(pc, binormals[i1]);
        GLKVector3 pt = GLKVector3Add(pc, tangents[i1]);
        
        GLKVector3 a[2];
        
        a[0] = pc;
        a[1] = pn;
        
        
        
        [[AHShaderManager manager] useColorProgram];
        
        GLKVector4 _color = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
        [[AHGraphicsManager manager] drawPointerArrayPosition:a
                                                     andColor:_color
                                                     andCount:2 
                                                  andDrawType:GL_LINES];
        
        _color = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
        a[1] = pb;
        
        [[AHGraphicsManager manager] drawPointerArrayPosition:a
                                                     andColor:_color
                                                     andCount:2 
                                                  andDrawType:GL_LINES];
        
        _color = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
        a[1] = pt;
        
        [[AHGraphicsManager manager] drawPointerArrayPosition:a
                                                     andColor:_color
                                                     andCount:2 
                                                  andDrawType:GL_LINES];
        
        [[AHShaderManager manager] useNormalProgram];
    }
}


#pragma mark -
#pragma mark cleanup


- (void)cleanupAfterRemoval {
    if (vertices) {
        free(vertices);
    }
    if (textures) {
        free(textures);
    }
    if (indices) {
        free(indices);
    }
    if (normals) {
        free(normals);
    }
    if (tangents) {
        free(tangents);
    }
    if (binormals) {
        free(binormals);
    }
    [self removeFromParentLayer];
}


#pragma mark -
#pragma mark textures


- (void)setTextureKey:(NSString *)key {
    _baseTexture = [[AHTextureManager manager] textureForKey:key];
}

- (void)setNormalTextureKey:(NSString *)key {
    _normalTexture = [[AHTextureManager manager] textureForKey:key];
}

- (AHTextureInfo *)baseTexture {
    return _baseTexture;
}

- (AHTextureInfo *)normalTexture {
    return _normalTexture;
}


#pragma mark -
#pragma mark draw


- (void)draw {
    if (_baseTexture) {
        [[AHTextureManager manager] activateBaseTexture:[_baseTexture name]];
    }
    if (_normalTexture) {
        [[AHTextureManager manager] activateNormalTexture:[_normalTexture name]];
        [[AHShaderManager manager] useNormalProgram];
    } else {
        [[AHShaderManager manager] useTextureProgram];
    }
    glPushGroupMarkerEXT(0, "Drawing Graphics Object");
    if (_isOffset) {
        [[AHGraphicsManager manager] modelPush];
        if (_rotation == 0.0f) {
            [[AHGraphicsManager manager] modelMove:_position];
        } else {
            [[AHGraphicsManager manager] modelMove:_position thenRotate:_rotation];
        }
    } else if (_rotation != 0.0f) {
        [[AHGraphicsManager manager] modelPush];
        [[AHGraphicsManager manager] modelRotate:_rotation];
    }
    if (_count > 0) {
        [self drawActual];
    }
    if (_isOffset || _rotation != 0.0f) {
        [[AHGraphicsManager manager] modelPop];
    }
    glPopGroupMarkerEXT();
}

- (void)drawActual {
    //glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    //glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD, 2, GL_FLOAT, GL_FALSE, 0, (void*)0);
    //glEnableVertexAttribArray(AH_SHADER_ATTRIB_POS_COORD);
    //glVertexAttribPointer(AH_SHADER_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, self->textures);
    //glEnableVertexAttribArray(AH_SHADER_ATTRIB_TEX_COORD);
    
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _arrayId);
    //glDrawElements(GL_TRIANGLE_STRIP, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, (void*)0);
    
    glVertexAttribPointer(AH_SHADER_ATTRIB_TEX_COORD,   2, GL_FLOAT, GL_FALSE, 0, self->textures);
    glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD,   3, GL_FLOAT, GL_FALSE, 0, self->vertices);
    glVertexAttribPointer(AH_SHADER_ATTRIB_NOR_COORD,   3, GL_FLOAT, GL_FALSE, 0, self->normals);
    glVertexAttribPointer(AH_SHADER_ATTRIB_BINOR_COORD, 3, GL_FLOAT, GL_FALSE, 0, self->binormals);
    glVertexAttribPointer(AH_SHADER_ATTRIB_TAN_COORD,   3, GL_FLOAT, GL_FALSE, 0, self->tangents);
	
    //glDrawArrays(_drawType, 0, _count);
    glDrawElements(_drawType, _indexCount, GL_UNSIGNED_BYTE, self->indices);
    //glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    [self drawNormals];
}

- (void)setDrawType:(GLenum)drawType {
    _drawType = drawType;
}


#pragma mark -
#pragma mark offset


- (void)setPosition:(GLKVector2)position {
    _position = position;
    if (position.x == 0 && position.y == 0) {
        _isOffset = NO;
    } else {
        _isOffset = YES;
    }
}

- (GLKVector2)position {
    return _position;
}

- (void)setRotation:(float)rotation {
    _rotation = rotation;
}


#pragma mark -
#pragma mark update


- (void)update {
    
}


@end
