#pragma header

uniform float progress;
uniform float pixelSize; 

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec4 color = flixel_texture2D(bitmap, uv);

    
    vec2 grid = floor(openfl_TextureCoordv * openfl_TextureSize / pixelSize);
    
    
    float chess = mod(grid.x + grid.y, 2.0);

    
   
    float threshold = progress * 2.0;
    
    if (progress > 0.0) {
        if (chess < threshold - (uv.y + uv.x) * 0.1) { 
            color = vec4(0.0, 0.0, 0.0, 1.0); 
        }
    }

    gl_FragColor = color;
}