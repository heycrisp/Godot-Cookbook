extends ThirdPersonControllerState

func _enter(_p, _d = {}) -> void:
	tpc.velocity.y = tpc.wall_slide_velocity
	tpc.animation_state.travel("Wall_Slide_Idle")

func _do_physics_process(delta) -> void:
	if tpc.is_on_floor():
		finished.emit(IWR, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif !tpc.is_on_wall():
		finished.emit(FALL, generate_delta_dictionary(delta, "_do_physics_process"))
		return
	elif Input.is_action_pressed("jump"):
		tpc.last_movement_direction = tpc.get_wall_normal() * tpc.speed
		tpc.look_forward(1.0)
		tpc.velocity = tpc.get_wall_normal() * tpc.speed
		tpc.velocity.y = tpc.jump_velocity
		tpc.move_and_slide()
		finished.emit(WALL_JUMP)
		return
	
	tpc.move_and_slide()
