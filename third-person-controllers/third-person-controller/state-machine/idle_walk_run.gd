extends ThirdPersonControllerState

func _do_physics_process(delta: float) -> void:
	if tpc.is_start_dash():
		finished.emit(DASH)
		return
	elif not tpc.is_on_floor():
		finished.emit(FALL)
		return
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMP)
		return

	tpc._do_iwr(delta)
	tpc.move_and_slide()
