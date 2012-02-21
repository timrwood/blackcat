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
varying vec3 norcoord_frag;

uniform mat4 projection;
uniform mat4 modelview;
uniform mat4 normalMatrix;

uniform vec3 lightPosition;
varying vec3 lightPosition_frag;


void main(void) {
    vec4 modelSpace = modelview * poscoord;
    
    // set position + texture position
    gl_Position = projection * modelSpace;
    texcoord_frag = texcoord;
    
    // calc normal for this vertex
    norcoord_frag = vec3(normalMatrix * norcoord);
    
    lightPosition_frag = lightPosition - vec3(modelSpace);
}