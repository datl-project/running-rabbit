shader_type canvas_item;

uniform bool whiten = false;

void fragment() {
	vec4 texture_color = texture(TEXTURE,UV);
	if (whiten){
		vec3 white = vec3(1,1,1);
		vec3 whiten_texture_rg = mix(texture_color.rgb,white,0.63);
		COLOR = vec4(whiten_texture_rg,texture_color.a);
	}else{
		COLOR = texture_color;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
