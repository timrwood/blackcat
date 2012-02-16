//
//  Shader.vsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


attribute vec4 poscoord;
attribute vec2 texcoord;
attribute vec4 norcoord;

uniform mat4 projection;
uniform mat4 normalMatrix;
uniform mat4 modelview;
uniform vec3 lightPosition;

varying highp vec2 texcoord_frag;
varying highp vec3 norcoord_frag;
varying highp vec3 lightPosition_frag;

varying lowp float diffuse;


void main(void) {
    // set position
    gl_Position = projection * modelview * poscoord;
    
    // set tex coord
    texcoord_frag = texcoord;
    
    // calc normal for this vertex
    //norcoord_frag = vec3(normalMatrix * norcoord);
    
    diffuse = max(dot(vec3(normalMatrix * norcoord), normalize(lightPosition)), 0.5);
    
    // calc light pos
    //lightPosition_frag = normalize(lightPosition);
}