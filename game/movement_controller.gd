extends Node

class_name MovementController

var player : CharacterBody3D
var move_direction := Vector3.ZERO

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
	
func move_horizontal(move_direction: Vector3, speed: float, acceleration: float, delta: float) -> void:
	var y_velocity := player.velocity.y

	player.velocity.y = 0.0
	player.velocity = player.velocity.move_toward(
		move_direction * speed,
		acceleration * delta
	)
	player.velocity.y = y_velocity
	
func apply_gravity(gravity: float, delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
		
func jump(jump_impulse: float) -> void:
	if player.is_on_floor():
		player.velocity.y = jump_impulse

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
	
func move() -> void:
	player.move_and_slide()
