extends ThirdPersonControllerState

func _enter(_p, _d = {}) -> void:
	pass

func _exit() -> void:
	pass

func _do_physics_process(delta: float) -> void:
	if not tpc.is_on_floor():
		finished.emit(FALL)
		return
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMP)
		return

	tpc._do_iwr(delta)
	tpc.move_and_slide()