extends State

func Enter():
	print("Entered Run")

func Physics_Update(_delta: float):
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input.length() <= 0.1:
		Transitioned.emit(self, "Idle")
