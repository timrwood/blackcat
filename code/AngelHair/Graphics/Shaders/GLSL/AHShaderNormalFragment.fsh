//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


varying highp vec2 texcoord_frag;
varying highp vec3 norcoord_frag;
varying highp vec3 binorcoord_frag;
varying highp vec3 tancoord_frag;

varying highp vec3 lightPosition_frag;
varying lowp float diffuse;

uniform highp mat4 normalMatrix;

uniform sampler2D textureBase;
uniform sampler2D textureNormal;

void main(void) {
    // get normal from texture
    highp vec3 nor = normalize(texture2D(textureNormal, texcoord_frag).rgb) * 2.0 - 1.0; 
    
    highp vec3 normal = normalize(nor.x * tancoord_frag + nor.y * binorcoord_frag + nor.z * norcoord_frag);
    
    // average it with the vertex normals
    highp float diffuse2 = max(dot(normal, normalize(vec3(0.0, 0.5, -0.5))), 0.0);
    
    // apply it to the color
    highp vec3 color = diffuse2 * texture2D(textureBase, texcoord_frag).rgb;  
    
    // set the color with the alpha as 1
    //gl_FragColor = vec4(nor, 1.0);
    gl_FragColor = vec4(color, 1.0);
    //gl_FragColor = vec4(norcoord_frag, 1.0);
    //gl_FragColor = vec4(normal, 1.0);
}
