extends ThirdPersonControllerState

func _do_physics_process(d) -> void:
	# print("Jump _do_physics_process")
	tpc.velocity.y = tpc.jump_velocity
	tpc.move_and_slide()
	finished.emit(FALL, {
		"delta": d,
		"func": "_do_physics_process"
	})