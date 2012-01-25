//
//  Shader.vsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//

attribute vec4 position;
attribute vec4 sourceColor;

varying vec4 destColor;

uniform mat4 projection;
uniform mat4 modelview;


void main(void) {
    destColor = sourceColor;
    gl_Position = projection * modelview * position;
}