//
//  Shader.vsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


attribute vec4 poscoord;
attribute vec2 texcoord;
varying highp vec2 texcoord_frag;

attribute vec4 norcoord;
attribute vec4 binorcoord;
attribute vec4 tancoord;

uniform mat4 projection;
uniform mat4 modelview;
uniform mat4 normalMatrix;

uniform vec3 lightPosition;

varying vec3 lightVec; 
varying vec3 eyeVec;


void main(void) {
    vec4 modelSpace = modelview * poscoord;
    
    // set position + texture position
    gl_Position = projection * modelSpace;
    texcoord_frag = texcoord;
    
    // calc normal for this vertex
    vec3 n = vec3(normalMatrix * norcoord);
    vec3 t = vec3(normalMatrix * tancoord);
    vec3 b = cross(n, t);
    
    vec3 vVertex = -vec3(gl_Position);
    
    lightVec = lightPosition - vec3(modelSpace);
    
    // calculate the light vector
	//lightVec.x = dot(tmpVec, t);
	//lightVec.y = dot(tmpVec, b);
	//lightVec.z = dot(tmpVec, n);
    
    // calculate the eye vector
	eyeVec.x = dot(vVertex, t);
	eyeVec.y = dot(vVertex, b);
	eyeVec.z = dot(vVertex, n);
}