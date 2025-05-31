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
	var delta = data.get("delta")
	var event = data.get("event")
	var func_name = data.get("func")
	# print("Base _enter: delta=%s event=%s, func_name=%s" % [delta, event, func_name])
	match func_name:
		"_do_unhandled_input" when event: _do_unhandled_input(event)
		"_do_process" when delta: _do_process(delta)
		"_do_physics_process" when delta: _do_physics_process(delta)

func _exit() -> void:
	pass

func generate_delta_dictionary(delta: float, func_name: String) -> Dictionary: return {
	"delta": delta,
	"func": func_name
}

func generate_input_dictionary(event: InputEvent, func_name: String) -> Dictionary: return {
	"event": event,
	"func": func_name
}