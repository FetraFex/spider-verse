extends State

func Enter():
	print("Entered Run")

func Physics_Update(delta: float):
	var move_direction = player.movement_controller.move_direction

	player.movement_controller.move_horizontal(
		move_direction,
		player.move_speed,
		player.acceleration,
		delta
	)
	
	player.movement_controller.apply_gravity(player.gravity, delta)

	if move_direction.length() <= 0.1:
		Transitioned.emit(self, "Idle")
		
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "Airborne")
