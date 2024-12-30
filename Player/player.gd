extends CharacterBody3D

const SPEED = 4
const RotSpeed = 10

@onready var mesh = $TempPlayerAnimated1
@onready var joystick = $"UI/Virtual Joystick"

const animation_idle = "Player|Idle"
const animation_idle_speed = 1
const animation_run = "Player|Run"
const animation_run_speed = 1.5

func _physics_process(delta: float) -> void:
	# Add gravity
	if is_on_floor():
		# Get input direction
		var input_dir := Vector2.ZERO
		if joystick.is_pressed:
			input_dir = joystick.output
		else:
			input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction := Vector3(input_dir.x, 0, input_dir.y)#.normalized()
		
		# Update velocity and rotate the mesh
		if direction != Vector3.ZERO:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

			# Smoothly rotate the mesh to face the movement direction using quaternions
			var target_rotation = Quaternion(Basis(Vector3.UP, atan2(direction.x, direction.z)))
			var current_rotation = mesh.global_transform.basis.get_rotation_quaternion()
			var smooth_rotation = current_rotation.slerp(target_rotation, delta * RotSpeed)
			mesh.global_transform = Transform3D(smooth_rotation, mesh.global_transform.origin)
			mesh.get_node("AnimationPlayer").play(animation_run)
			mesh.get_node("AnimationPlayer").speed_scale = (velocity.length()/SPEED) * animation_run_speed
			
			print(velocity.length()/SPEED)
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			mesh.get_node("AnimationPlayer").play(animation_idle)
			mesh.get_node("AnimationPlayer").speed_scale = 1 * animation_idle_speed
		
	else:
		velocity += get_gravity() * delta

	# Move the player
	move_and_slide()
