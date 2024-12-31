shader_type canvas_item;

uniform float speed = 2.0; // Speed of the wobble
uniform float amplitude = 0.03; // Amplitude of the wobble
uniform float frequency = 10.0; // Frequency of the wobble

void fragment() {
    vec2 center = vec2(0.5, 0.5); // Center of the texture
    vec2 offset = UV - center; // Relative position to the center

    // Apply wobble effect (scaled to reduce edge distortion)
    offset.x -= sin(UV.y * frequency + TIME * speed) * amplitude * (1.0 - abs(offset.x) * 2.0);
    offset.y -= cos(UV.x * frequency + TIME * speed) * amplitude * (1.0 - abs(offset.y) * 2.0);

    // Recalculate UVs based on the constrained offset
    vec2 wobble_uv = center + offset;

    // Fetch texture color without wrapping or distortion
    COLOR = texture(TEXTURE, wobble_uv);
}
