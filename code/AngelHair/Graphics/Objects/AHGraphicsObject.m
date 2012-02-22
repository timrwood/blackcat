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
        _drawStaticDynamic = GL_STATIC_DRAW;
        
        glGenBuffers(1, &_bufferId);
        glGenBuffers(1, &_arrayId);
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark cache


- (void)setDynamicBuffer:(BOOL)dynamicBuffer {
    if (dynamicBuffer) {
        _drawStaticDynamic = GL_DYNAMIC_DRAW;
    } else {
        _drawStaticDynamic = GL_STATIC_DRAW;
    }
}

- (void)bufferVertices {
    glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    glBufferData(GL_ARRAY_BUFFER, _count * sizeof(AHVertex), vertices, _drawStaticDynamic);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)bufferIndices {
    //dlog(@"buffering indices for %@ to %i", self, _arrayId);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _arrayId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount * sizeof(GLubyte), indices, _drawStaticDynamic);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
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
    [self bufferVertices];
    [self bufferIndices];
}


#pragma mark -
#pragma mark vertices


- (void)setVertexCount:(int)newCount {
    if (_count != newCount) {
        if (vertices) {
            free(vertices);
        }
    }
    _count = newCount;
    vertices = (AHVertex *) malloc(sizeof(AHVertex) * _count);
}

- (void)setIndexCount:(int)newCount {
    if (_indexCount != newCount) {
        if (indices) {
            free(indices);
        }
    }
    _indexCount = newCount;
    indices = (GLubyte *) malloc(sizeof(GLubyte) * _indexCount);
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
        GLKVector3 p1 = vertices[i1].position;
        GLKVector3 p2 = vertices[i2].position;
        GLKVector3 p3 = vertices[i3].position;
        
        // textures
        GLKVector2 t1 = vertices[i1].texture;
        GLKVector2 t2 = vertices[i2].texture;
        GLKVector2 t3 = vertices[i3].texture;
        
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
        vertices[i1].normal = normal;
        vertices[i2].normal = normal;
        vertices[i3].normal = normal;
        
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
        
        //binormals[i1] = binormal;
        //binormals[i2] = binormal;
        //binormals[i3] = binormal;
        
        vertices[i1].tangent = tangent;
        vertices[i2].tangent = tangent;
        vertices[i3].tangent = tangent;
    }
}

- (void)drawNormals {
    for (int i = 0; i < _indexCount; i += 3) {
        // indices
        int i1 = indices[i];
        int i2 = indices[i + 1];
        int i3 = indices[i + 2];
        
        // positions
        GLKVector3 p1 = vertices[i1].position;
        GLKVector3 p2 = vertices[i2].position;
        GLKVector3 p3 = vertices[i3].position;
        
        GLKVector3 pc = GLKVector3DivideScalar(GLKVector3Add(GLKVector3Add(p1, p2), p3), 3.0f);
        GLKVector3 pn = GLKVector3Add(pc, vertices[i1].normal);
        GLKVector3 pt = GLKVector3Add(pc, vertices[i1].tangent);
        GLKVector3 pb = GLKVector3Add(pc, GLKVector3CrossProduct(vertices[i1].normal, vertices[i1].tangent));
        
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
    if (indices) {
        free(indices);
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

- (void)activateTextures {
    if (_baseTexture) {
        [[AHTextureManager manager] activateBaseTexture:[_baseTexture name]];
    }
    if (_normalTexture) {
        [[AHTextureManager manager] activateNormalTexture:[_normalTexture name]];
        [[AHShaderManager manager] useNormalProgram];
    } else {
        [[AHShaderManager manager] useTextureProgram];
    }
}


#pragma mark -
#pragma mark draw


- (void)draw {
    [self activateTextures];
    
    // drawing graphics object
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
    // bind data buffers
    glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    glVertexAttribPointer(AH_SHADER_ATTRIB_POS_COORD, 3, GL_FLOAT, GL_FALSE, sizeof(AHVertex), (void *) 0);
    glVertexAttribPointer(AH_SHADER_ATTRIB_NOR_COORD, 3, GL_FLOAT, GL_FALSE, sizeof(AHVertex), (void *) (3 * sizeof(float)));
    glVertexAttribPointer(AH_SHADER_ATTRIB_TAN_COORD, 3, GL_FLOAT, GL_FALSE, sizeof(AHVertex), (void *) (6 * sizeof(float)));
    glVertexAttribPointer(AH_SHADER_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, sizeof(AHVertex), (void *) (9 * sizeof(float)));
    
    // draw elements in indices array
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _arrayId);
    glDrawElements(_drawType, _indexCount, GL_UNSIGNED_BYTE, 0);
    
    // reset buffers
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    //[self drawNormals];
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
