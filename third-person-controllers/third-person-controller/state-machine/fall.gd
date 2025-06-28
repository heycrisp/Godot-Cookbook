extends ThirdPersonControllerState

func _enter(_p, _d = {}) -> void:
	tpc.animation_state.travel("Fall_Idle")

func _do_physics_process(delta: float) -> void:
	# print("Fall _do_physics_process")
	if tpc.is_start_dash():
		finished.emit(DASH, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif tpc.is_on_floor():
		finished.emit(IWR, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif tpc.is_wall_slide and tpc.is_on_wall():
		finished.emit(WALL_SLIDE, generate_delta_dictionary(delta, "do_physics_process"))
		return
	
	tpc._do_fall(delta)

	if tpc.is_mid_air_movement:
		tpc._do_iwr(delta)
	tpc.move_and_slide()