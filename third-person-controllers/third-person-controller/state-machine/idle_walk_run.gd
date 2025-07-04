extends ThirdPersonControllerState

var last_input_direction := Vector2.ZERO

func _enter(p, _d = {}) -> void:
	if [FALL, WALL_JUMP].has(p):
		tpc.animation_state.travel("Fall_Land")

func _do_physics_process(delta: float) -> void:
	# print("IWR _do_physics_process")
	if tpc.is_start_dash():
		finished.emit(DASH, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif not tpc.is_on_floor():
		finished.emit(FALL, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMP, generate_delta_dictionary(delta, "_do_physics_process"))
		return

	tpc._do_iwr(delta)
	tpc.move_and_slide()

	tpc.animation_tree.set("parameters/IWR/blend_position", tpc.velocity.length())

	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction != last_input_direction:
		input_direction = lerp(last_input_direction, input_direction, tpc.rotation_speed * delta)
		last_input_direction = input_direction
	tpc.animation_tree.set("parameters/IWR_Strafe/blend_position", input_direction)
