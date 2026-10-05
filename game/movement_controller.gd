extends Node

class_name MovementController

var player : CharacterBody3D
var move_direction := Vector3.ZERO

@onready var skin: Node3D = $"../Miles"

func update_input(camera: Camera3D) -> void:
	get_move_direction(camera)

func get_move_direction(camera: Camera3D) -> Vector3:
	var raw_input := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var forward := camera.global_basis.z
	var right := camera.global_basis.x

	move_direction = raw_input.y * forward + raw_input.x * right
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	return move_direction.normalized()
	
func move_horizontal(move_direction: Vector3, speed: float, delta: float) -> void:
	var y_velocity := player.velocity.y

	player.velocity.x = move_direction.x * speed
	player.velocity.z = move_direction.z * speed
	player.velocity.y = y_velocity
	
func apply_gravity(gravity: float, delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
		
func jump(jump_impulse: float) -> void:
	if player.is_on_floor():
		player.velocity.y = jump_impulse

func sprint_jump(jump_impulse: float, forward_speed: float) -> void:
	player.velocity.y = jump_impulse

	var direction := move_direction

	if direction.length() > 0.1:
		player.velocity += direction * forward_speed
	print("SPRINT JUMP VELOCITY: ", player.velocity)

func rotate_toward_movement(
	move_direction: Vector3,
	rotation_speed: float,
	delta: float
) -> void:
	if move_direction.length() > 0.2:
		player.last_movement_direction = move_direction

	var target_angle := Vector3.BACK.signed_angle_to(
		player.last_movement_direction,
		Vector3.UP
	)

	player.skin.global_rotation.y = lerp_angle(
		player.skin.rotation.y,
		target_angle,
		rotation_speed * delta
	)
	
func update_facing(direction: Vector3, rotation_speed: float, delta: float) -> void:
	if direction.length() <= 0.2:
		return

	var target_angle := Vector3.BACK.signed_angle_to(
		direction,
		Vector3.UP
	)

	skin.global_rotation.y = lerp_angle(
		skin.rotation.y,
		target_angle,
		rotation_speed * delta
	)
	
func move() -> void:
	player.move_and_slide()
