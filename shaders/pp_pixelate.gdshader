shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform int pixel_size = 4;


void vertex() {
	POSITION = vec4(VERTEX.xy, 1, 1);
}

void fragment() {
	float x = float(int(FRAGCOORD.x) % pixel_size);
	float y = float(int(FRAGCOORD.y) % pixel_size);

	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - y;

	vec2 pos = vec2(x, y) / VIEWPORT_SIZE;

	ALBEDO = texture(SCREEN_TEXTURE, pos).rgb;
}
