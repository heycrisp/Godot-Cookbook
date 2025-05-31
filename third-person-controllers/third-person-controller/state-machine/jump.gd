extends ThirdPersonControllerState

func _do_physics_process(_d) -> void:
	# print("Jump _do_physics_process")
	tpc.velocity.y = tpc.jump_velocity
	tpc.move_and_slide()
	_POST_do_physics_process()

# _POST prefix == Done processing player this frame
func _POST_do_physics_process() -> void:
	finished.emit(FALL)