extends CharacterBody3D

@onready var model: Node3D = $Model
@onready var twist_pivot: Node3D = $Twist
@onready var pitch_pivot: Node3D = $Twist/Pitch

func _unhandled_input(event: InputEvent) -> void:
	_capture_unhandled_mouse_event(event)

func _process(delta: float) -> void:
	_camera_rotate_twist(delta)
	_camera_rotate_pitch(delta)

func _physics_process(delta: float) -> void:
	_do_iwr(delta)

@export_category("Movement Options")
@export var speed := 5.0
@export var rotation_speed := 12.0
# These will be added in later PRs
# @export var jump_velocity := 4.5
# @export var dash_speed := 10.0
# @export var dash_length := 5.0
# @export var dash_cooldown := 0.2
# var dash_direction: Vector3
# var dash_length_remaining := 0.0
# var dash_cooldown_timer := 0.0

var _last_movement_direction := Vector3.FORWARD

func _do_iwr(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_magnitude := minf(input_vector.length(), 1)
	var input_direction = input_vector.normalized()
	
	if input_direction == Vector2.ZERO:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	else:
		_last_movement_direction = Vector3(input_direction.x, 0, input_direction.y).rotated(Vector3.UP, twist_pivot.rotation.y) * input_magnitude * speed
		velocity.x = _last_movement_direction.x
		velocity.z = _last_movement_direction.z
		
	var target_angle := Vector3.FORWARD.signed_angle_to(_last_movement_direction, Vector3.UP)
	model.rotation.y = lerp_angle(model.rotation.y, target_angle, rotation_speed * delta)
	move_and_slide()

	
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
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			return

	if event is InputEventMouseMotion:
		twist_input_mouse = _mouse_clamp(event.relative.x * camera_mouse_sensitivity, mouse_input_clamp)
		pitch_input_mouse = _mouse_clamp(event.relative.y * camera_mouse_sensitivity, mouse_input_clamp)
