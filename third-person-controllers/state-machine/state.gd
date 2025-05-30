class_name State extends Node

@warning_ignore("UNUSED_SIGNAL")
signal finished(next_state_path: String, data: Dictionary)

func _unhandled_input(_event: InputEvent) -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

func _enter(_previous_state_path: String, _data := {}) -> void:
	pass

func _exit() -> void:
	pass