extends Camera3D

@onready var camera_close = $CameraLow
@onready var camera_mid = $CameraMid
@onready var camera_far = $CameraHigh

@export var transition_speed = 4.0

# The target camera to lerp toward
var target_camera : Camera3D

func _ready():
	# Start with the mid camera
	target_camera = camera_mid
	transform = target_camera.transform

func _process(delta):
	# Lerp position and rotation toward the target camera
	transform.origin = transform.origin.lerp(target_camera.global_transform.origin, delta * transition_speed)
	var target_basis = target_camera.global_transform.basis
	transform.basis = transform.basis.slerp(target_basis, delta * transition_speed)

func set_camera(camera: Camera3D):
	target_camera = camera

func set_camera_close():
	set_camera(camera_close)

func set_camera_mid():
	set_camera(camera_mid)

func set_camera_far():
	set_camera(camera_far)
