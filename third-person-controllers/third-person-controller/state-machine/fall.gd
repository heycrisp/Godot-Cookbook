extends ThirdPersonControllerState

func _do_physics_process(delta: float) -> void:
	# print("Fall _do_physics_process")
	if tpc.is_start_dash():
		finished.emit(DASH, generate_delta_dictionary(delta, "_do_phsics_process"))
		return
	elif tpc.is_on_floor():
		finished.emit(IWR, generate_delta_dictionary(delta, "_do_phsics_process"))
		return
	
	tpc._do_fall(delta)
	if tpc.is_mid_air_movement:
		tpc._do_iwr(delta)
	tpc.move_and_slide()