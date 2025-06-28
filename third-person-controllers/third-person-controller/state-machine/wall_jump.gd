extends ThirdPersonControllerState

func _enter(_p, _d = {}) -> void:
	tpc.animation_state.travel("Jump")

func _do_physics_process(delta) -> void:
	if tpc.is_on_floor():
		finished.emit(IWR, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif tpc.is_on_wall():
		finished.emit(WALL_SLIDE, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif tpc.is_start_dash():
		finished.emit(DASH, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	
	tpc._do_fall(delta)
	tpc.move_and_slide()