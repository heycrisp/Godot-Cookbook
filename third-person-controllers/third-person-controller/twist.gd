class_name ThirdPersonController_Twist extends Node3D

var tpc: ThirdPersonController

func _ready() -> void:
	await owner.ready
	tpc = owner as ThirdPersonController
	assert(tpc != null, "ThirdPersonController_Twist must be a child of ThirdPersonController.")

func _unhandled_input(event: InputEvent) -> void:
	_capture_unhandled_mouse_event(event)

func _process(delta: float) -> void:
	_camera_rotate_twist(delta)
	_camera_rotate_pitch(delta)

func _physics_process(delta: float) -> void:
	_follow_player(delta)

@onready var pitch_pivot: Node3D = $Pitch

@export_category("Camera Options")
@export var camera_init_twist := 0.0
@export var camera_init_pitch := 0.0
@export var camera_lock_twist := false
@export var camera_lock_pitch := false
@export var camera_mouse_sensitivity := 0.001
@export var camera_pitch_min := -30.0
@export var camera_pitch_max := 30.0
@export var look_invert_x := true
@export var look_invert_y := false

var twist_input_mouse := 0.0
var pitch_input_mouse := 0.0
var mouse_input_clamp := 1.0

var last_camera_lag := 0.0
var _last_movement_direction := Vector3.FORWARD

func _on_player_last_movement_direction_updated(direction: Vector3) -> void:
	_last_movement_direction = direction

func _get_camera_look_vector() -> Vector2:
	var look_vector := Input.get_vector("look_left", "look_right", "look_down", "look_up")
	if look_vector.length() > 1:
		return look_vector.normalized()

	return look_vector


func _camera_rotate_twist(delta: float) -> void:
	if not camera_lock_twist:
		var twist_input := _get_camera_look_vector().x * delta
		if twist_input == 0:
			twist_input = twist_input_mouse
		
		if look_invert_x:
			twist_input *= -1

		rotate_y(twist_input)

	twist_input_mouse = 0.0

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

func _mouse_clamp(value: float, size: float) -> float: return clampf(value, -size, size)

func _capture_unhandled_mouse_event(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			return

	if event is InputEventMouseMotion:
		twist_input_mouse = _mouse_clamp(event.screen_relative.x * camera_mouse_sensitivity, mouse_input_clamp)
		pitch_input_mouse = _mouse_clamp(event.screen_relative.y * camera_mouse_sensitivity, mouse_input_clamp)

func _follow_player(_delta: float) -> void:
	last_camera_lag = 0.15
	position = lerp(position, tpc.position, last_camera_lag)
