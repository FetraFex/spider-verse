extends State

func Enter():
	print("Entered Run")
	player.play_animation("Start Run")

func Physics_Update(delta: float):
	var move_direction = player.movement_controller.move_direction
	
	var is_sprinting := Input.is_action_pressed("Sprint")
	
	if is_sprinting:
		player.play_animation("Sprint")
	else:
		player.play_animation("Run")
	
	var current_speed = player.sprint_speed if is_sprinting else player.move_speed
	
	
	player.movement_controller.move_horizontal(
		move_direction,
		current_speed,
		delta
	)
	
	player.movement_controller.apply_gravity(player.gravity, delta)

	if move_direction.length() <= 0.1:
		Transitioned.emit(self, "Idle")
		
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "Airborne")
