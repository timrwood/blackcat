//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


varying highp vec2 texcoord_frag;
varying highp vec3 norcoord_frag;
varying highp vec3 lightPosition_frag;
varying lowp float diffuse;

uniform bool isNormalEnabled;

uniform sampler2D textureBase;
uniform sampler2D textureNormal;

void main(void) {
    //gl_FragColor = texture2D(textureBase, texcoord_frag) * vec4(diffuse, diffuse, diffuse, 1.0);
    
    //gl_FragColor = vec4(norcoord_frag, 1.0);
    
    gl_FragColor = vec4(diffuse, diffuse, diffuse, 1.0);
}
