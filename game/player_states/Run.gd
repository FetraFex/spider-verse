extends State

# Start Run
const ANIMATION_FPS := 30.0
const START_RUN_FRAMES := 11.0
const START_RUN_DURATION := START_RUN_FRAMES / ANIMATION_FPS

var start_run_elapsed := 0.0
var is_starting := true

# Stop Run
const STOP_RUN_FRAMES := 14.0
const STOP_RUN_DURATION := STOP_RUN_FRAMES / 30.0

var is_stopping := false
var stop_elapsed := 0.0
var stop_start_velocity := Vector3.ZERO

func Enter():
	print("Entered Run")
	is_stopping = false
	stop_elapsed = 0.0
	
	start_run_elapsed = 0.0
	is_starting = true
	
	player.play_animation("Start Run")

func Physics_Update(delta: float):
	var move_direction = player.movement_controller.move_direction
	var has_input = move_direction.length() > 0.1

	# Le saut reste possible à tout moment
	if Input.is_action_just_pressed("jump"):
		is_stopping = false
		Transitioned.emit(self, "Airborne")
		return

	# --- Phase d'arrêt ---
	if is_stopping:
		# Le joueur ré-appuie : on repart directement
		if has_input:
			is_stopping = false
			is_starting = true
			start_run_elapsed = 0.0
			player.play_animation("Start Run")
			return

		stop_elapsed += delta
		var progress := clampf(stop_elapsed / STOP_RUN_DURATION, 0.0, 1.0)

		var remaining_speed := 1.0 - progress
		remaining_speed = remaining_speed * remaining_speed * (3.0 - 2.0 * remaining_speed)

		player.velocity.x = stop_start_velocity.x * remaining_speed
		player.velocity.z = stop_start_velocity.z * remaining_speed
		player.movement_controller.apply_gravity(player.gravity, delta)

		if progress >= 1.0:
			player.velocity.x = 0.0
			player.velocity.z = 0.0
			is_stopping = false
			Transitioned.emit(self, "Idle")
		return

	# --- Détection du relâchement (avant move_horizontal) ---
	if not has_input:
		stop_start_velocity = Vector3(player.velocity.x, 0.0, player.velocity.z)
		is_stopping = true
		stop_elapsed = 0.0
		player.movement_controller.apply_gravity(player.gravity, delta)
		player.play_animation("StopRun")
		return

	# --- Course normale ---
	var is_sprinting := Input.is_action_pressed("sprint")
	var target_speed = player.sprint_speed if is_sprinting else player.move_speed

	if is_starting:
		start_run_elapsed += delta
		var progress := clampf(start_run_elapsed / START_RUN_DURATION, 0.0, 1.0)
		var eased_progress := progress * progress * (3.0 - 2.0 * progress)

		player.movement_controller.move_horizontal(move_direction, target_speed * eased_progress)

		if progress >= 1.0:
			is_starting = false
			player.play_animation("Sprint" if is_sprinting else "Run")
	else:
		player.movement_controller.move_horizontal(move_direction, target_speed)
		player.play_animation("Sprint" if is_sprinting else "Run")

	player.movement_controller.apply_gravity(player.gravity, delta)
