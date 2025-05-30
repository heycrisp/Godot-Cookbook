class_name State extends Node

@warning_ignore_start("unused_parameter", "unused_signal")
signal finished(next_state_path: String, data: Dictionary)

func _do_unhandled_input(event: InputEvent) -> void:
	pass

func _do_process(delta: float) -> void:
	pass

func _do_physics_process(delta: float) -> void:
	pass

func _enter(previous_state_path: String, data := {}) -> void:
	pass

func _exit() -> void:
	pass