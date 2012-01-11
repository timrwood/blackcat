//
//  AHDebugDraw.cpp
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#include "AHDebugDraw.h"
#import <GLKit/GLKit.h>

#include <cstdio>
#include <cstdarg>
#include <cstring>



AHDebugDraw::AHDebugDraw() {
    
}

void AHDebugDraw::DrawPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color) {
	b2Vec2 *vertices = new b2Vec2[vertexCount];
	for( int i=0;i<vertexCount;i++) {
		vertices[i] = old_vertices[i];
	}
    
	glColor4f(color.r, color.g, color.b, 0.5f);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
    
    dlog(@"draw poly");
}

void AHDebugDraw::DrawSolidPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color) {
	b2Vec2 *vertices = new b2Vec2[vertexCount];
	for( int i=0;i<vertexCount;i++) {
		vertices[i] = old_vertices[i];
	}
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glColor4f(color.r*0.5f, color.g*0.5f, color.b*0.5f, 1);
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	
	glColor4f(color.r, color.g, color.b, 0.5f);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
    
    dlog(@"draw solid poly");
}

void AHDebugDraw::DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color) {
	const float32 k_segments = 16.0f;
	int vertexCount=16;
	const float32 k_increment = 2.0f * b2_pi / k_segments;
	float32 theta = 0.0f;
	
	GLfloat glVertices[vertexCount*2];
	for (int32 i = 0; i < k_segments; ++i) {
		b2Vec2 v = center + radius * b2Vec2(cosf(theta), sinf(theta));
		glVertices[i*2]=v.x;
		glVertices[i*2+1]=v.y;
		theta += k_increment;
	}
	
	glColor4f(color.r, color.g, color.b,1);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, glVertices);
	
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
    
    dlog(@"draw circle");
}

void AHDebugDraw::DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color){
	const float32 k_segments = 16.0f;
	int vertexCount=16;
	const float32 k_increment = 2.0f * b2_pi / k_segments;
	float32 theta = 0.0f;
	
	GLfloat glVertices[vertexCount*3];
	for (int32 i = 0; i < k_segments; ++i) {
		b2Vec2 v = center + radius * b2Vec2(cosf(theta), sinf(theta));
		glVertices[i*2] = v.x;
		glVertices[i*2+1] = v.y;
		theta += k_increment;
	}
	
	glColor4f(color.r *0.5f, color.g*0.5f, color.b*0.5f,1);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, glVertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	glColor4f(color.r, color.g, color.b,1);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
	
	// Draw the axis line
	DrawSegment(center,center+radius*axis,color);
}

void AHDebugDraw::DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color){
	glColor4f(color.r, color.g, color.b, .5);
	GLfloat glVertices[] = {
		p1.x, p1.y,
		p2.x, p2.y
	};
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, glVertices);
	glDrawArrays(GL_LINES, 0, 2);
}

void AHDebugDraw::DrawTransform(const b2Transform& xf) {
	b2Vec2 p1 = xf.p, p2;
	const float32 k_axisScale = 0.4f;
    
    p2 = p1 + k_axisScale * xf.q.GetXAxis();
    DrawSegment(p1, p2, b2Color(1,0,0));
    
    p2 = p1 + k_axisScale * xf.q.GetYAxis();
    DrawSegment(p1, p2, b2Color(0,1,0));
}

void AHDebugDraw::DrawPoint(const b2Vec2& p, float32 size, const b2Color& color) {
	glColor4f(color.r, color.g, color.b,1);
	glPointSize(size);
	GLfloat glVertices[] = {
		p.x, p.y
	};
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, glVertices);
	glDrawArrays(GL_POINTS, 0, 1);
	glPointSize(1.0f);
}

void AHDebugDraw::DrawString(int x, int y, const char *string, ...) {
    //	DLog(@"DrawString: unsupported: %s", string);
	//printf(string);
	/* Unsupported as yet. Could replace with bitmap font renderer at a later date */
}

void AHDebugDraw::DrawAABB(b2AABB* aabb, const b2Color& c) {
	glColor4f(c.r, c.g, c.b,1);
    
	GLfloat glVertices[] = {
		aabb->lowerBound.x, aabb->lowerBound.y,
		aabb->upperBound.x, aabb->lowerBound.y,
		aabb->upperBound.x, aabb->upperBound.y,
		aabb->lowerBound.x, aabb->upperBound.y
	};
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, glVertices);
	glDrawArrays(GL_LINE_LOOP, 0, 8);
}

