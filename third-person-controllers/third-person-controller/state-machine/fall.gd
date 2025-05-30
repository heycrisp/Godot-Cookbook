extends ThirdPersonControllerState

func _enter(_p, _d = {}) -> void:
	pass

func _exit() -> void:
	pass

func _do_physics_process(delta: float) -> void:
	if tpc.is_on_floor():
		finished.emit(IWR)
		return
	
	tpc._do_fall(delta)
	tpc.move_and_slide()