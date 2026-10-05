extends State

func Enter():
	print("Entered Airborne")
	if Input.is_action_pressed("Sprint") and player.movement_controller.move_direction.length() > 0.1:
		player.movement_controller.sprint_jump(
			player.sprint_jump_impulse,
			player.sprint_jump_forward_speed
		)
		player.play_animation("StartJump")
	else:
		player.movement_controller.jump(player.jump_impulse)

func Exit():
	print("Exit Airborne")

func Physics_Update(delta: float):
	player.movement_controller.apply_gravity(player.gravity, delta)

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
