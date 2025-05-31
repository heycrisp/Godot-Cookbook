extends ThirdPersonControllerState

func _do_physics_process(_d) -> void:
	tpc.velocity.y = tpc.jump_velocity
	tpc.move_and_slide()
	finished.emit(FALL)