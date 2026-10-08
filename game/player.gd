extends CharacterBody3D


@export_group("Movement")
@export var move_speed := 3.0
@export var sprint_speed := 6.0
@export var rotation_speed := 12.0
@export var jump_impulse := 30.0
@export var sprint_jump_impulse := 30.0
@export var sprint_jump_forward_speed := 60.0

var last_movement_direction := Vector3.BACK
var gravity := -30.0
var animation_playback: AnimationNodeStateMachinePlayback


@onready var movement_controller: MovementController = $MovementController
@onready var animation_tree: AnimationTree = $Miles/AnimationTree
@onready var camera: Camera3D = %Camera3D

func _ready() -> void:
	movement_controller.player = self
	animation_playback = animation_tree.get("parameters/playback")
	print("AnimationTree: ", animation_tree)
	print("Animation Playback: ", animation_playback)

func _physics_process(delta: float) -> void:
	movement_controller.update_input(camera)
	movement_controller.move()

	movement_controller.update_facing(movement_controller.move_direction, rotation_speed, delta)

func play_animation(state_name: String) -> void:
	if animation_playback.get_current_node() == state_name:
		return

	animation_playback.travel(state_name)
