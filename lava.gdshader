shader_type spatial;
render_mode unshaded;

// Uniforms for customization
uniform sampler2D noise_texture : source_color;
uniform float speed : hint_range(0.0, 2.0) = 0.05;
uniform vec2 flow_direction = vec2(0.7, 0.3);
uniform float distortion_strength : hint_range(0.0, 1.0) = 0.2;
uniform float lava_scale : hint_range(0.1, 5.0) = 0.8;

// Color controls
uniform vec4 lava_color1 : source_color = vec4(1.0, 0.3, 0.0, 1.0);
uniform vec4 lava_color2 : source_color = vec4(0.8, 0.1, 0.0, 1.0);
uniform vec4 hot_spots_color : source_color = vec4(1.0, 0.6, 0.1, 1.0);

// Brightness and glow
uniform float brightness : hint_range(0.0, 3.0) = 0.8;
uniform float glow_intensity : hint_range(0.0, 2.0) = 0.5;

// Time tracking
uniform float time_scale = 0.3;  // Reduced from 1.0

void vertex() {
	// Slower vertex displacement
	VERTEX.y += sin(TIME * 0.2 + VERTEX.x * 0.3) * 0.02;
}

void fragment() {
	// Get UV coordinates
	vec2 uv = UV * lava_scale;
	
	// Create flowing motion with time - MUCH SLOWER
	float time = TIME * time_scale * speed;
	vec2 flow = flow_direction * time * 0.1;  // Reduced flow speed
	
	// Sample multiple noise layers for complex movement
	vec2 uv1 = uv + flow * 0.5;   // Reduced multipliers
	vec2 uv2 = uv * 1.2 - flow * 0.3;
	vec2 uv3 = uv * 0.8 + flow * 0.4;
	
	// Get noise values
	float noise1 = texture(noise_texture, uv1).r;
	float noise2 = texture(noise_texture, uv2).g;
	float noise3 = texture(noise_texture, uv3).b;
	
	// Combine noises
	float combined_noise = (noise1 * 0.5 + noise2 * 0.3 + noise3 * 0.2);
	
	// Create distortion - SLOWER
	vec2 distorted_uv = uv + vec2(
		sin(combined_noise * 5.0 + time * 0.5) * distortion_strength * 0.05,  // Reduced multipliers
		cos(combined_noise * 4.0 + time * 0.4) * distortion_strength * 0.05
	);
	
	// Sample final noise with distortion
	float final_noise = texture(noise_texture, distorted_uv).r;
	
	// Create moving patterns for lava - SLOWER
	float pattern1 = sin(final_noise * 8.0 + time * 0.8) * 0.5 + 0.5;  // Reduced frequency
	float pattern2 = cos(final_noise * 6.0 + time * 0.6) * 0.5 + 0.5;
	
	// Mix colors based on noise patterns
	vec4 base_color = mix(lava_color1, lava_color2, pattern1);
	
	// Add hot spots (brighter areas)
	float hotspots = pattern2 * final_noise * 0.7;  // Reduced hotspot intensity
	base_color = mix(base_color, hot_spots_color, hotspots * 0.2);  // Reduced mixing
	
	// Apply brightness
	base_color.rgb *= brightness;
	
	// Add glow effect
	float glow = final_noise * glow_intensity * 0.5;  // Reduced glow
	base_color.rgb += glow * hot_spots_color.rgb * 0.3;
	
	// Output final color
	ALBEDO = base_color.rgb;
	
	// Make it emissive
	EMISSION = base_color.rgb * glow_intensity * 0.7;  // Reduced emission
	
	// Roughness variation
	ROUGHNESS = 0.8 - hotspots * 0.2;  // Reduced variation
	
	// Metallic effect
	METALLIC = 0.1 + hotspots * 0.2;  // Reduced variation
}