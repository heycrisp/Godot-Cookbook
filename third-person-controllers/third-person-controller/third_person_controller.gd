class_name ThirdPersonController extends CharacterBody3D

signal last_movement_direction_updated(direction: Vector3)

func _ready() -> void:
	twist_pivot.top_level = true
	$HealthBar3d.set_max_value(max_hp)
	$HealthBar3d.update_healthbar(hp)

@onready var model: Node3D = $Model
@onready var twist_pivot: Node3D = $Twist

@export_category("Health Options")
@export var hp := 10.0:
	set(v):
		hp = v
		$HealthBar3d.update_healthbar(v)

@export var max_hp := 10.0:
	set(v):
		max_hp = v
		$HealthBar3d.set_max_value(v)


@export_category("Movement Options")
@export var speed := 5.0
@export var rotation_speed := 12.0
@export var jump_velocity := 4.5
@export var dash_speed := 10.0
@export var dash_length := 5.0
@export var dash_cooldown := 0.3
@export var is_dash_hold := false
@export var is_mid_air_movement := true

var is_dash_ready := true
var _last_movement_direction := Vector3.FORWARD
var _look_direction := Vector3.FORWARD

func is_start_dash() -> bool: return (
	is_dash_ready and
	(
		Input.is_action_just_pressed("dash") or
		(
			is_dash_hold and
			Input.is_action_pressed("dash")
		)
	)
)

func get_last_movement_direction() -> Vector3: return _last_movement_direction
func set_last_movement_direction(direction: Vector3) -> void:
	_last_movement_direction = direction
	_look_direction = direction
	last_movement_direction_updated.emit(direction)

func look_forward(weight: float) -> void:
	var target_angle := Vector3.FORWARD.signed_angle_to(_look_direction, Vector3.UP)
	model.rotation.y = lerp_angle(model.rotation.y, target_angle, weight)

func _do_dash() -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var dash_direction := (
		Vector3(input_vector.x, 0, input_vector.y).rotated(Vector3.UP, twist_pivot.rotation.y) if input_vector else
		Vector3.FORWARD.rotated(Vector3.UP, model.rotation.y)
	).normalized()
	
	var direction = dash_direction * dash_speed
	velocity.x = direction.x
	velocity.z = direction.z
	velocity.y = 0
	set_last_movement_direction(dash_direction)

func _end_dash() -> void:
	velocity.x = move_toward(velocity.x, speed, dash_speed)
	velocity.z = move_toward(velocity.z, speed, dash_speed)

func _do_iwr(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_magnitude := minf(input_vector.length(), 1)
	var input_direction = input_vector.normalized()
	
	if input_direction == Vector2.ZERO:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	else:
		set_last_movement_direction(Vector3(input_direction.x, 0, input_direction.y).rotated(Vector3.UP, twist_pivot.rotation.y) * input_magnitude * speed)
		velocity.x = _last_movement_direction.x
		velocity.z = _last_movement_direction.z
		
	look_forward(rotation_speed * delta)

func _do_fall(delta: float) -> void:
	velocity += get_gravity() * delta
