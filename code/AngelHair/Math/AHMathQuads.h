//
//  AHMathQuads.h
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#ifndef BlackCat_AHMathQuads_h
#define BlackCat_AHMathQuads_h


union _AHPolygonQuad {
    struct { GLKVector2 a, b, c, d; };
    GLKVector2 p[4];
};
typedef union _AHPolygonQuad AHPolygonQuad;


static __inline__ GLKVector2 AHPolygonQuadCentroid(AHPolygonQuad quad);
static __inline__ GLKVector2 AHPolygonQuadCentroid(AHPolygonQuad quad) {
    GLKVector2 all = GLKVector2Add(GLKVector2Add(GLKVector2Add(quad.a, quad.b), quad.c), quad.d);
    return GLKVector2DivideScalar(all, 4.0f);
}

static __inline__ AHPolygonQuad AHPolygonQuadAddVector(AHPolygonQuad quad, GLKVector2 vector);
static __inline__ AHPolygonQuad AHPolygonQuadAddVector(AHPolygonQuad quad, GLKVector2 vector) {
    return (AHPolygonQuad) {
        GLKVector2Add(quad.a, vector),
        GLKVector2Add(quad.b, vector),
        GLKVector2Add(quad.c, vector),
        GLKVector2Add(quad.d, vector)
    };
}

static __inline__ AHPolygonQuad AHPolygonQuadSubtractVector(AHPolygonQuad quad, GLKVector2 vector);
static __inline__ AHPolygonQuad AHPolygonQuadSubtractVector(AHPolygonQuad quad, GLKVector2 vector) {
    return (AHPolygonQuad) {
        GLKVector2Subtract(quad.a, vector),
        GLKVector2Subtract(quad.b, vector),
        GLKVector2Subtract(quad.c, vector),
        GLKVector2Subtract(quad.d, vector)
    };
}

static __inline__ AHPolygonQuad AHPolygonQuadMultiplyScalar(AHPolygonQuad quad, float scalar);
static __inline__ AHPolygonQuad AHPolygonQuadMultiplyScalar(AHPolygonQuad quad, float scalar) {
    return (AHPolygonQuad) {
        GLKVector2MultiplyScalar(quad.a, scalar),
        GLKVector2MultiplyScalar(quad.b, scalar),
        GLKVector2MultiplyScalar(quad.c, scalar),
        GLKVector2MultiplyScalar(quad.d, scalar)
    };
}

static __inline__ AHPolygonQuad AHPolygonQuadDivideScalar(AHPolygonQuad quad, float scalar);
static __inline__ AHPolygonQuad AHPolygonQuadDivideScalar(AHPolygonQuad quad, float scalar) {
    return (AHPolygonQuad) {
        GLKVector2DivideScalar(quad.a, scalar),
        GLKVector2DivideScalar(quad.b, scalar),
        GLKVector2DivideScalar(quad.c, scalar),
        GLKVector2DivideScalar(quad.d, scalar)
    };
}


#endif
