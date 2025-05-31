extends ThirdPersonControllerState

func _do_physics_process(delta: float) -> void:
	# print("Fall _do_physics_process")
	if tpc.is_start_dash():
		finished.emit(DASH, {
			"delta": delta,
			"func": "_do_physics_process"
		})
		return
	elif tpc.is_on_floor():
		finished.emit(IWR, {
			"delta": delta,
			"func": "_do_physics_process"
		})
		return
	
	tpc._do_fall(delta)
	tpc.move_and_slide()