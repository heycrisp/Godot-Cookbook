extends ThirdPersonControllerState

func _do_physics_process(delta: float) -> void:
	if tpc.is_start_dash():
		finished.emit(DASH)
		return
	elif tpc.is_on_floor():
		finished.emit(IWR)
		return
	
	tpc._do_fall(delta)
	tpc.move_and_slide()