extends SpringArm3D

@export var sensitivity := 0.1
@export var zoom_min := 3.0
@export var zoom_max := 5.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				spring_length = maxf(zoom_min, spring_length - sensitivity)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				spring_length = minf(zoom_max, spring_length + sensitivity)
