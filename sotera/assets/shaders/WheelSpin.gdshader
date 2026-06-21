shader_type canvas_item;

uniform float offset = 0.3;

void fragment() {
	vec2 uv = UV.xy;
	uv.y = modf(uv.y + offset, uv.y);
	COLOR = texture(TEXTURE, uv);
}
