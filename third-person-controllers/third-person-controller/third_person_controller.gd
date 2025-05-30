class_name ThirdPersonController extends CharacterBody3D

@onready var model: Node3D = $Model
@onready var twist_pivot: Node3D = $Twist

@export_category("Movement Options")
@export var speed := 5.0
@export var rotation_speed := 12.0
@export var jump_velocity := 4.5
# These will be added in later PRs
# @export var dash_speed := 10.0
# @export var dash_length := 5.0
# @export var dash_cooldown := 0.2
# var dash_direction: Vector3
# var dash_length_remaining := 0.0
# var dash_cooldown_timer := 0.0

var _last_movement_direction := Vector3.FORWARD

func _do_iwr(delta: float) -> void:
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

func _do_fall(delta: float) -> void:
	velocity += get_gravity() * delta
