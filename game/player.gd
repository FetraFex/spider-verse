extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 12.0

var _camera_input_direction := Vector2.ZERO
var last_movement_direction := Vector3.BACK
var gravity := -30.0

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var camera : Camera3D = %Camera3D
@onready var movement_controller: MovementController = $MovementController
@onready var visual_controller: VisualController = $VisualController

func _ready() -> void:
	movement_controller.player = self
	visual_controller.player = self
	
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("left_click")):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if (event.is_action_pressed("ui_cancel")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity


func _physics_process(delta: float) -> void:
	movement_controller.update_input(camera)
	
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 6.0, PI / 30)

	_camera_pivot.rotation.y -= _camera_input_direction.x * delta 
	
	_camera_input_direction = Vector2.ZERO
	
	movement_controller.move()

	visual_controller.update_facing(movement_controller.move_direction, rotation_speed, delta)
