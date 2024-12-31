shader_type spatial;

uniform float bend_strength : hint_range(0.0, 1.0, 0.01) = 0.2; // Controls the bending strength
uniform vec3 bend_axis = vec3(1.0, 0.0, 0.0); // Bending around the X-axis

void vertex() {
    // Calculate the bend effect based on the vertex position
    float distance = VERTEX.z; // Adjust the axis if needed
    float bend = distance * distance * bend_strength;

    // Apply bending along the specified axis
    VERTEX += bend * bend_axis;
}
