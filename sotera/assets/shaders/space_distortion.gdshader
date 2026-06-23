shader_type canvas_item;

uniform vec2 target_center = vec2(0.5);
uniform float power: hint_range(-10.0, 10.0, 0.01) = 2.0;
uniform float iterations: hint_range(1.0, 20.0, 1.0) = 10.0;

uniform float radial_noise_effect: hint_range(0.0, 5.0, 0.01) = 2.0;
uniform sampler2D radial_noise;
uniform sampler2D noise;
uniform float immunity_range: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float anime_noise_effect: hint_range(0.0, 1.0, 0.01) = 0.2;

uniform vec3 outside_color: source_color = vec3(0.0, 0.0, 1.0);

// --- Glow Params ---
uniform vec3 glow_color: source_color = vec3(1.0);
uniform float glow_radius = 0.5;
uniform float glow_size = 0.03;


vec4 sample_radial_noise_color(vec2 uv, sampler2D tex){
	vec2 dir = target_center - uv;
	vec2 blur = dir * power * 0.01;
	
	vec4 noise_offset = texture(radial_noise, uv);
	
	vec3 color = vec3(0.0);
	for(float i = 0.0; i < iterations; i++){
		color += texture(tex, uv).rgb;
		uv += blur;
	}
	
	color = clamp(color/iterations, 0.0, 1.0);
	return vec4(color, 1.0);
}

vec4 texture_radial(vec2 uv, sampler2D tex, float t){
	float aspect = 1920.0 / 1080.0;
	vec2 dir = target_center - uv;
	dir.x *= aspect;
	float len = length(dir);
	
	float immunity = (len - immunity_range) * step(immunity_range, len);
	vec2 anim_noise = texture(
		noise,
		fract(uv + vec2(t * 0.02))
	).rg - 0.5;
	
	float d = len - glow_radius * 0.5 + anim_noise.r * 0.2;

	// soft falloff
	float glow_center = step(d, glow_size);
	float glow_ring = glow_center * step(0.0, d);
	
	vec2 shift = target_center - vec2(0.5);
	vec2 shifted_uv = uv - shift;
	
	vec2 noise_offset = texture(radial_noise, shifted_uv).rg - 0.5;
	vec2 noise_uv = noise_offset * radial_noise_effect * immunity;
	vec2 final_uv = clamp(noise_uv * shifted_uv + uv + anim_noise * anime_noise_effect, 0.0, 1.0);
	
	vec3 A = texture(tex, final_uv).rgb;
	float alpha = anim_noise.r * radial_noise_effect * immunity;
	
	
	float center_only = glow_center * (1.0 - glow_ring);
	vec3 rgb = A * center_only + 		// mask 1 ... center
			   glow_color * glow_ring + // mask 2 ... glow
			  (1.0 - glow_center) * outside_color; 	// mask 3 ... outside
			
	return vec4(rgb, 1.0);
}

void fragment() {
	vec4 color1 = texture_radial(UV, TEXTURE, TIME);
	//vec4 color2 = sample_radial_noise_color(UV, TEXTURE);
	//COLOR = clamp((color1 + color2) * 0.5, 0.0, 1.0);
	COLOR = color1;
}