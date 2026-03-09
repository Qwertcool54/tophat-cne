#pragma header

uniform float thickness;
uniform vec4 outlineColor;

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 color = flixel_texture2D(bitmap, uv);

    if (color.a > 0.0) {
        gl_FragColor = color;
        return;
    }

    float tx = thickness / openfl_TextureSize.x;
    float ty = thickness / openfl_TextureSize.y;

    float a = 0.0;
    a += flixel_texture2D(bitmap, uv + vec2(tx, 0.0)).a;
    a += flixel_texture2D(bitmap, uv + vec2(-tx, 0.0)).a;
    a += flixel_texture2D(bitmap, uv + vec2(0.0, ty)).a;
    a += flixel_texture2D(bitmap, uv + vec2(0.0, -ty)).a;

    if (a > 0.0)
        gl_FragColor = outlineColor;
    else
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}