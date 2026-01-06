shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float reflection_blur : hint_range(0.0, 10.0) = 0.0;

void fragment() {
    vec2 reflected_uv = vec2(1.0 - SCREEN_UV.x, SCREEN_UV.y);
    vec3 screen_color = textureLod(screen_texture, reflected_uv, reflection_blur).rgb;

    ALBEDO = screen_color;
    METALLIC = 0.8;
    ROUGHNESS = 0.05;
}