extends Node
class_name VisualController

var player: CharacterBody3D

@onready var skin: Node3D = %Manequin

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
