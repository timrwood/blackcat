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
varying highp vec3 lightPosition_frag;

uniform mat4 projection;
uniform mat4 modelview;
uniform vec3 lightPosition;


void main(void) {
    texcoord_frag = texcoord;
    
    gl_Position = projection * modelview * poscoord;
    
    lightPosition_frag = normalize(lightPosition);
}