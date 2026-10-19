shader_type canvas_item;
uniform sampler2D ruido : repeat_enable, filter_linear;
uniform vec4 color : source_color = vec4(0.62, 0.72, 0.72, 1.0);
uniform float densidad = 0.42;
uniform vec2 velocidad = vec2(0.010, 0.004);
uniform vec2 repeticion = vec2(6.0, 3.5);

void fragment() {
	vec2 uv = UV * repeticion;
	float a = texture(ruido, uv + TIME * velocidad).r;
	float b = texture(ruido, uv * 1.7 - TIME * velocidad * 1.4 + vec2(0.37, 0.11)).r;
	float n = smoothstep(0.38, 0.82, a * 0.6 + b * 0.4);
	COLOR = vec4(color.rgb, n * densidad);
}
