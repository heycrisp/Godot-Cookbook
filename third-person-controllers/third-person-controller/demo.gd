extends Node3D

func _ready() -> void:
	_capture_mouse()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_release_mouse()
		else:
			_capture_mouse()
	

func _release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)