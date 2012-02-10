//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


varying lowp vec2 lightPosition;
varying lowp vec2 texcoordFragment;

uniform bool isNormalEnabled;

uniform sampler2D textureBase;
uniform sampler2D textureNormal;

void main(void) {
    if (isNormalEnabled) {
        
        // Extract the normal from the normal map  
        lowp vec3 normal = normalize(texture2D(textureNormal, texcoordFragment).rgb * 2.0 - 1.0);  
        
        // Determine where the light is positioned (this can be set however you like)  
        lowp vec3 light_pos = normalize(vec3(-1.0, -1.0, 1.5));  
        
        // Calculate the lighting diffuse value  
        lowp float diffuse = max(dot(normal, normalize(vec3(lightPosition, 0.5))), 0.0);  
        //lowp float diffuse = max(dot(normal, light_pos), 0.0);  
        
        lowp vec3 color = diffuse * texture2D(textureBase, texcoordFragment).rgb;  
        
        // Set the output color of our current pixel  
        gl_FragColor = vec4(color, 1.0); 
         
        //gl_FragColor = texture2D(textureNormal, texcoordFragment);
    } else {
        gl_FragColor = texture2D(textureBase, texcoordFragment);
    }
}
