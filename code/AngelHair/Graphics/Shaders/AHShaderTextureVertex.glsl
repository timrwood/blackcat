//
//  Shader.vsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


attribute vec4 poscoord;
attribute vec2 texcoord;

varying lowp vec2 texcoordFragment;
varying lowp vec2 lightPosition;

uniform mat4 projection;
uniform mat4 modelview;


void main(void) {
    texcoordFragment = texcoord;
    
    gl_Position = projection * modelview * poscoord;
    
    lightPosition = vec2(gl_Position) + vec2(0.5, 0.5);
}