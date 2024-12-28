extends CharacterBody3D

const SPEED = 4
const RotSpeed = 10

@onready var mesh = $MeshInstance3D

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor:
		velocity += get_gravity() * delta

	# Get input direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	# Update velocity and rotate the mesh
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Smoothly rotate the mesh to face the movement direction using quaternions
		var target_rotation = Quaternion(Basis(Vector3.UP, atan2(direction.x, direction.z)))
		var current_rotation = mesh.global_transform.basis.get_rotation_quaternion()
		var smooth_rotation = current_rotation.slerp(target_rotation, delta * RotSpeed)
		mesh.global_transform = Transform3D(smooth_rotation, mesh.global_transform.origin)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Move the player
	move_and_slide()
