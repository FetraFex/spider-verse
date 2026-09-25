extends State

func Enter():
	print("Entered Airborne")
	player.movement_controller.jump(player.jump_impulse)

func Exit():
	print("Exit Airborne")

func Physics_Update(delta: float):
	player.movement_controller.apply_gravity(player.gravity, delta)

	player.movement_controller.move_horizontal(
		Vector3.ZERO,
		player.move_speed,
		player.acceleration,
		delta
	)
	
	if player.is_on_floor():
		var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

		if input.length() > 0.1:
			Transitioned.emit(self, "Run")
		else:
			Transitioned.emit(self, "Idle")
