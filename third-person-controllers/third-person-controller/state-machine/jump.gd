extends ThirdPersonControllerState

func _enter(_p, _d = {}) -> void:
	pass

func _exit() -> void:
	pass

func _do_physics_process(_d) -> void:
	tpc.velocity.y = tpc.jump_velocity
	tpc.move_and_slide()
	finished.emit(FALL)