extends Camera3D

var tpc: ThirdPersonController

func _ready() -> void:
	await owner.ready
	tpc = owner as ThirdPersonController
	assert(tpc != null, "Invalid root node detected")

func _unhandled_input(event: InputEvent) -> void:
	_capture_unhandled_mouse_event(event)

func _physics_process(delta: float) -> void:
	_camera_rotate_twist(delta)
	_camera_rotate_pitch(delta)

@export var aim_mouse_sensitivity := 0.001
@export var aim_invert_x := true
@export var aim_invert_y := true

var twist_input_mouse := 0.0
var pitch_input_mouse := 0.0
var mouse_input_clamp := 1.0

func _get_aim_look_vector() -> Vector2:
	var look_vector := Input.get_vector("look_left", "look_right", "look_down", "look_up")
	if look_vector.length() > 1:
		return look_vector.normalized()

	return look_vector

func _camera_rotate_twist(delta: float) -> void:
	var twist_input := _get_aim_look_vector().x * delta
	if twist_input == 0:
		twist_input = twist_input_mouse
	
	if aim_invert_x:
		twist_input *= -1

	tpc.rotate_y(twist_input)
	tpc.twist_pivot.rotation.y = tpc.rotation.y

	twist_input_mouse = 0.0

func _camera_rotate_pitch(delta: float) -> void:
	var pitch_input := _get_aim_look_vector().y * delta
	if pitch_input == 0:
		pitch_input = pitch_input_mouse

	if aim_invert_y:
		pitch_input *= -1

	tpc.model.rotate_x(pitch_input)

	pitch_input_mouse = 0.0

func _mouse_clamp(value: float, absolute_limit: float) -> float: return clampf(value, -absolute_limit, absolute_limit)

func _capture_unhandled_mouse_event(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED: return

	if event is InputEventMouseMotion:
		twist_input_mouse = _mouse_clamp(event.screen_relative.x * aim_mouse_sensitivity, mouse_input_clamp)
		pitch_input_mouse = _mouse_clamp(event.screen_relative.y * aim_mouse_sensitivity, mouse_input_clamp)
