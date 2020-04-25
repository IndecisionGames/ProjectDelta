shader_type canvas_item;

void fragment() {
    // Get the vertex color or the color from the texture if set
    vec4 finalColor = min(texture(TEXTURE, UV), COLOR);

    if(AT_LIGHT_PASS) {
        // For all fragments in the light we just use the input color
        COLOR = finalColor;
    } else {
        // For all other fragments we make them B&W
        COLOR = vec4(0, 0, 0, 0.0);
    }
}