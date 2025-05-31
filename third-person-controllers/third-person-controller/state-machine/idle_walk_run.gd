extends ThirdPersonControllerState

func _do_physics_process(delta: float) -> void:
	# print("IWR _do_physics_process")
	if tpc.is_start_dash():
		finished.emit(DASH, {
			"delta": delta,
			"func": "_do_physics_process"
		})
		return
	elif not tpc.is_on_floor():
		finished.emit(FALL, {
			"delta": delta,
			"func": "_do_physics_process"
		})
		return
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMP, {
			"delta": delta,
			"func": "_do_physics_process"
		})
		return

	tpc._do_iwr(delta)
	tpc.move_and_slide()
