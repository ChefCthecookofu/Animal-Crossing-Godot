shader_type sky;
render_mode use_debanding;

// Uniforms to configure the gradient colors and appearance
uniform vec4 sky_top_color : source_color = vec4(0.385, 0.454, 0.55, 1.0);
uniform vec4 sky_horizon_color : source_color = vec4(0.646, 0.656, 0.67, 1.0);
uniform float sky_curve : hint_range(0, 1) = 0.15;
uniform float sky_energy = 1.0;

uniform vec4 ground_bottom_color : source_color = vec4(0.2, 0.169, 0.133, 1.0);
uniform vec4 ground_horizon_color : source_color = vec4(0.646, 0.656, 0.67, 1.0);
uniform float ground_curve : hint_range(0, 1) = 0.02;
uniform float ground_energy = 1.0;

uniform float exposure : hint_range(0, 128) = 1.0;

// Sun parameters
uniform float sun_angle_max = 30.0;
uniform float sun_curve : hint_range(0, 1) = 0.15;
uniform vec4 sun_color : source_color = vec4(1.0, 1.0, 0.8, 1.0);

void sky() {
    // Compute the vertical angle of the view direction
    float v_angle = acos(clamp(EYEDIR.y, -1.0, 1.0));

    // Calculate the sky gradient
    float c = (1.0 - v_angle / (PI * 0.5));
    vec3 sky = mix(sky_horizon_color.rgb, sky_top_color.rgb, 
                   clamp(1.0 - pow(1.0 - c, 1.0 / max(sky_curve, 0.01)), 0.0, 1.0));
    sky *= sky_energy;

    // Sun effect from directional light
    if (LIGHT0_ENABLED) {
        float sun_angle = acos(dot(LIGHT0_DIRECTION, EYEDIR));
        if (sun_angle < LIGHT0_SIZE) {
            float sun_brightness = 1.0 - (sun_angle / LIGHT0_SIZE);
            vec3 sun_disk = sun_color.rgb * sun_brightness;
            sky = mix(sky, sun_disk, sun_brightness);
        } else if (sun_angle < sun_angle_max) {
            float c2 = (sun_angle - LIGHT0_SIZE) / (sun_angle_max - LIGHT0_SIZE);
            sky = mix(LIGHT0_COLOR * LIGHT0_ENERGY, sky, 
                      clamp(1.0 - pow(1.0 - c2, 1.0 / sun_curve), 0.0, 1.0));
        }
    }

    // Calculate the ground gradient
    c = (v_angle - (PI * 0.5)) / (PI * 0.5);
    vec3 ground = mix(ground_horizon_color.rgb, ground_bottom_color.rgb, 
                      clamp(1.0 - pow(1.0 - c, 1.0 / max(ground_curve, 0.01)), 0.0, 1.0));
    ground *= ground_energy;

    // Combine sky and ground based on the view direction
    COLOR = mix(ground, sky, step(0.0, EYEDIR.y)) * exposure;
}
