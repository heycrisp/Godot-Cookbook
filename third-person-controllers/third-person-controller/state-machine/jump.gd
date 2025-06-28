extends ThirdPersonControllerState

func _enter(_p, _d = {}) -> void:
	tpc.animation_state.travel("Jump")
	tpc.velocity.y = tpc.jump_velocity

func _do_physics_process(_d) -> void:
	# print("Jump _do_physics_process")
	tpc.move_and_slide()
	_POST_do_physics_process()

# _POST prefix == Done processing player this frame
func _POST_do_physics_process() -> void:
	finished.emit(FALL)