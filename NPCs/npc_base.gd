extends CharacterBody3D

class_name NPC

const SPEED = 4
const ROT_SPEED = 10

@export var mesh_scene : PackedScene
@export var animation_idle_name : String = ""
@export var animation_idle_speed : float = 1.0
@export var animation_run_name : String = ""
@export var animation_run_speed : float = 1.0

@onready var mesh_inst: Node3D = null

func _ready() -> void:
	if mesh_scene:
		# Instantiate the new mesh from the PackedScene
		mesh_inst = mesh_scene.instantiate()
		add_child(mesh_inst)
		mesh_inst.name = "Mesh"  # Ensure the new mesh has the same name
	else:
		print("Warning: No mesh scene assigned to the NPC.")

func _physics_process(delta: float) -> void:
	if mesh_inst:
		# Add gravity and movement logic
		if is_on_floor():
			var direction := Vector3.ZERO

			# Example movement and rotation handling
			if direction != Vector3.ZERO:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED

				# Smoothly rotate the mesh to face the movement direction
				var target_rotation = Quaternion(Basis(Vector3.UP, atan2(direction.x, direction.z)))
				var current_rotation = mesh_inst.global_transform.basis.get_rotation_quaternion()
				var smooth_rotation = current_rotation.slerp(target_rotation, delta * ROT_SPEED)
				mesh_inst.global_transform = Transform3D(smooth_rotation, mesh_inst.global_transform.origin)
				play_animation(animation_run_name, (velocity.length() / SPEED) * animation_run_speed)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
				play_animation(animation_idle_name, animation_idle_speed)
		else:
			velocity += get_gravity() * delta

		# Move the character
		move_and_slide()

func play_animation(animation_name: String, speed: float) -> void:
	if mesh_inst and mesh_inst.has_node("AnimationPlayer"):
		var anim_player = mesh_inst.get_node("AnimationPlayer")
		anim_player.play(animation_name)
		anim_player.speed_scale = speed
