extends CharacterBody3D

@export_category("Camera Options")
@export var camera_init_twist := 0.0
@export var camera_init_pitch := 0.0
@export var camera_init_dist := 10.0
@export var camera_lock_twist := false
@export var camera_lock_pitch := false
@export var camera_lock_dist := true
@export var camera_mouse_sensitivity := 0.001
@export var camera_pitch_min := -30.0
@export var camera_pitch_max := 30.0
@export var camera_dist_min := 3.0
@export var camera_dist_max := 10.0
@export var look_invert_x := true
@export var look_invert_y := false

func _get_camera_look_vector() -> Vector2:
	var look_vector := Input.get_vector("look_left", "look_right", "look_down", "look_up")
	if look_vector.length() > 1:
		return look_vector.normalized()

	return look_vector

@onready var twist_pivot: Node3D = $Twist
var twist_input_mouse := 0.0
func _camera_rotate_twist(delta: float) -> void:
	if not camera_lock_twist:
		var twist_input := _get_camera_look_vector().x * delta
		if twist_input == 0:
			twist_input = twist_input_mouse
		
		if look_invert_x:
			twist_input *= -1

		twist_pivot.rotate_y(twist_input)

	twist_input_mouse = 0.0

@onready var pitch_pivot: Node3D = $Twist/Pitch
var pitch_input_mouse := 0.0
func _camera_rotate_pitch(delta: float) -> void:
	if not camera_lock_pitch:
		var pitch_input := _get_camera_look_vector().y * delta
		if pitch_input == 0:
			pitch_input = pitch_input_mouse

		if look_invert_y:
			pitch_input *= -1

		pitch_pivot.rotate_x(pitch_input)

	pitch_input_mouse = 0.0
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(camera_pitch_min),
		deg_to_rad(camera_pitch_max)
	)

var mouse_input_clamp := 1.0
func _mouse_clamp(value: float, size: float) -> float:
	return clampf(value, -size, size)

func _capture_unhandled_mouse_event(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			return

		twist_input_mouse = _mouse_clamp(event.relative.x * camera_mouse_sensitivity, mouse_input_clamp)
		pitch_input_mouse = _mouse_clamp(event.relative.y * camera_mouse_sensitivity, mouse_input_clamp)

func _unhandled_input(event: InputEvent) -> void:
	_capture_unhandled_mouse_event(event)

func _process(delta: float) -> void:
	_camera_rotate_twist(delta)
	_camera_rotate_pitch(delta)