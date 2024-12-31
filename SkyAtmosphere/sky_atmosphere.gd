extends Node3D

@onready var sun = $DirectionalLight3D
@export var sky: ProceduralSkyMaterial

@export var day_top_color = Color(0.38, 0.45, 0.55)
@export var day_horizon_color = Color(0.64, 0.65, 0.67)
@export var twilight_top_color = Color(0.21, 0.38, 0.38)
@export var twilight_horizon_color = Color(0.76, 0.24, 0.0)
@export var night_top_color = Color(0.0, 0.0, 0.1)
@export var night_horizon_color = Color(0.06, 0.14, 0.19)

@export var sun_energy_day = 1.0
@export var sun_energy_night = 0

var time_dict = Time.get_datetime_dict_from_system()
var time_of_day = time_dict["second"]
var norm_time_of_day = remap(time_of_day, 0, 86400, 0, 1)
var debug = true

func _process(_delta):
	# Get time in seconds and normalize it (0-1)
	time_dict = Time.get_datetime_dict_from_system()
	if debug and OS.has_feature("editor"):
		time_of_day = time_dict["second"]
		norm_time_of_day = remap(time_of_day, 0, 60, 0, 1)
	else:
		time_of_day = (time_dict["hour"] * 3600) + (time_dict["minute"] * 60) + time_dict["second"]
		norm_time_of_day = remap(time_of_day, 0, 86400, 0, 1)

	# Update the sun's rotation based on the time of day
	var sun_angle = 90 + (norm_time_of_day * -360)
	sun.rotation_degrees = Vector3(sun_angle, 0, 0)

	# Update the sky colors to simulate day and night transitions
	if sky:
		# Calculate the blending factor for the top and horizon colors using a cosine function.
		var blend_factor = (cos(norm_time_of_day * PI * 2) + 1) / 2  # This will oscillate between 0 and 1

		#Blend sky colors
		var top_color : Color
		var horizon_color : Color
		# Blend between noon and twilight
		if blend_factor <= 0.5:
			top_color = lerp(day_top_color, twilight_top_color, blend_factor / 0.5)
			horizon_color = lerp(day_horizon_color, twilight_horizon_color, blend_factor / 0.5)
		# Blend between twilight and midnight
		else:
			top_color = lerp(twilight_top_color, night_top_color, remap(blend_factor, 0.5, 1, 0, 1))
			horizon_color = lerp(twilight_horizon_color, night_horizon_color, remap(blend_factor, 0.5, 1, 0, 1))
		sky.sky_top_color = top_color
		sky.sky_horizon_color = horizon_color
		sky.ground_bottom_color = top_color
		sky.ground_horizon_color = horizon_color


		# Simulate sun intensity for day/night cycle
		sun.light_energy = remap(1 - blend_factor, 0, 1, sun_energy_night, sun_energy_day)
