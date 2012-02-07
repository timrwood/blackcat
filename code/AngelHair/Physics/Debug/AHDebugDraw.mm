//
//  AHDebugDraw.cpp
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>

#include "AHDebugDraw.h"
#import "AHGraphicsManager.h"


AHDebugDraw::AHDebugDraw() {
    
}

void AHDebugDraw::DrawPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color) {
	GLKVector2 glVertices[vertexCount];
	for (int i = 0; i < vertexCount; i++) {
		glVertices[i] = GLKVector2Make(old_vertices[i].x, old_vertices[i].y);
	}
    
    GLKVector4 _color = GLKVector4Make(color.r * 0.5f, color.g * 0.5f, color.b * 0.5f, 0.5f);
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:vertexCount 
                                              andDrawType:GL_LINE_LOOP];
}

void AHDebugDraw::DrawSolidPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color) {
	GLKVector2 glVertices[vertexCount];
	for (int i = 0; i < vertexCount; i++) {
		glVertices[i] = GLKVector2Make(old_vertices[i].x, old_vertices[i].y);
	}
    
    GLKVector4 _color = GLKVector4Make(color.r * 0.5f, color.g * 0.5f, color.b * 0.5f, 0.25f);
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:vertexCount 
                                              andDrawType:GL_TRIANGLE_FAN];
    _color.a = 0.5f;
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:vertexCount 
                                              andDrawType:GL_LINE_LOOP];
}

void AHDebugDraw::DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color) {
	const float32 k_segments = 16.0f;
	int vertexCount=16;
	const float32 k_increment = 2.0f * b2_pi / k_segments;
	float32 theta = 0.0f;
	
	GLKVector2 glVertices[vertexCount * 3];
	for (int32 i = 0; i < k_segments; ++i) {
		b2Vec2 v = center + radius * b2Vec2(cosf(theta), sinf(theta));
		glVertices[i] = GLKVector2Make(v.x, v.y);
		theta += k_increment;
	}
    
    GLKVector4 _color = GLKVector4Make(color.r * 0.5f, color.g * 0.5f, color.b * 0.5f, 0.25f);
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:vertexCount 
                                              andDrawType:GL_LINE_LOOP];
}

void AHDebugDraw::DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color){
	const float32 k_segments = 16.0f;
	int vertexCount = 16;
	const float32 k_increment = 2.0f * b2_pi / k_segments;
	float32 theta = 0.0f;
	
	GLKVector2 glVertices[vertexCount * 3];
	for (int32 i = 0; i < k_segments; ++i) {
		b2Vec2 v = center + radius * b2Vec2(cosf(theta), sinf(theta));
		glVertices[i] = GLKVector2Make(v.x, v.y);
		theta += k_increment;
	}
    
    GLKVector4 _color = GLKVector4Make(color.r * 0.5f, color.g * 0.5f, color.b * 0.5f, 0.25f);
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:vertexCount 
                                              andDrawType:GL_TRIANGLE_FAN];
    _color.a = 0.5f;
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:vertexCount 
                                              andDrawType:GL_LINE_LOOP];
	
	// Draw the axis line
	DrawSegment(center, center + radius * axis, color);
}

void AHDebugDraw::DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color){
    GLKVector2 glVertices[] = {
		p1.x, p1.y,
		p2.x, p2.y
	};
    
    
    GLKVector4 _color = GLKVector4Make(color.r * 0.5f, color.g * 0.5f, color.b * 0.5f, 0.5f);
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:2 
                                              andDrawType:GL_LINES];
}

void AHDebugDraw::DrawTransform(const b2Transform& xf) {
	b2Vec2 p1 = xf.p, p2;
	const float32 k_axisScale = 0.2f;
    
    p2 = p1 + k_axisScale * xf.q.GetXAxis();
    DrawSegment(p1, p2, b2Color(0, 0, 1.0f));
    
    p2 = p1 + k_axisScale * xf.q.GetYAxis();
    DrawSegment(p1, p2, b2Color(0, 1.0f, 0));
}

void AHDebugDraw::DrawPoint(const b2Vec2& p, float32 size, const b2Color& color) {
	glPointSize(size);
    
	GLKVector2 glVertices[] = {
		p.x, p.y
	};
    
    
    GLKVector4 _color = GLKVector4Make(color.r * 0.5f, color.g * 0.5f, color.b * 0.5f, 0.5f);
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:1 
                                              andDrawType:GL_POINTS];
}

void AHDebugDraw::DrawString(int x, int y, const char *string, ...) {
    //	DLog(@"DrawString: unsupported: %s", string);
	//printf(string);
	/* Unsupported as yet. Could replace with bitmap font renderer at a later date */
}

void AHDebugDraw::DrawAABB(b2AABB* aabb, const b2Color& color) {
	GLKVector2 glVertices[4] = {
		aabb->lowerBound.x, aabb->lowerBound.y,
		aabb->upperBound.x, aabb->lowerBound.y,
		aabb->upperBound.x, aabb->upperBound.y,
		aabb->lowerBound.x, aabb->upperBound.y
	};
    
    GLKVector4 _color = GLKVector4Make(color.r * 0.5f, color.g * 0.5f, color.b * 0.5f, 0.5f);
    
    [[AHGraphicsManager manager] drawPointerArrayPosition:glVertices
                                                 andColor:_color
                                                 andCount:8 
                                              andDrawType:GL_LINE_LOOP];
}

