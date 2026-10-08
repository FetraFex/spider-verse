extends Node

@export var mouse_sensitivity: float = 0.25
@export var min_pitch: float = -80.0
@export var max_pitch: float = 80.0

@onready var phantom_camera: PhantomCamera3D = $"../PhantomCamera3D"

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is not InputEventMouseMotion:
		return

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
		
	var camera_rotation := phantom_camera.get_third_person_rotation_degrees()
	
	camera_rotation.x -= event.relative.y * mouse_sensitivity
	camera_rotation.x = clampf(camera_rotation.x, min_pitch, max_pitch)
	camera_rotation.y -= event.relative.x * mouse_sensitivity
	
	phantom_camera.set_third_person_rotation_degrees(camera_rotation)
