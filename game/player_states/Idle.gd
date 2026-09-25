extends State

func Enter():
	print("Entered Idle")

func Exit():
	print("Exit Idle")
	
func Physics_Update(delta: float):
	player.movement_controller.apply_gravity(
		player.gravity,
		delta
	)

	player.movement_controller.move_horizontal(
		Vector3.ZERO,
		player.move_speed,
		player.acceleration,
		delta
	)

	if player.movement_controller.move_direction.length() > 0.1:
		Transitioned.emit(self, "Run")
		
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "Airborne")
