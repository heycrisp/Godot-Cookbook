class_name ThirdPersonController extends CharacterBody3D

func _ready() -> void:
	twist_pivot.top_level = true
	$HealthBar3d.set_max_value(max_hp)
	$HealthBar3d.update_healthbar(hp)
	free_camera.current = true
	aim_camera.process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta: float) -> void:
	_handle_aim()


@onready var model: Node3D = $Model
@onready var twist_pivot: Node3D = $Twist
@onready var free_camera: Camera3D = $Twist/Pitch/FreeCamSpringArm/FreeCamera
@onready var aim_camera: Camera3D = $Model/AimCamera
@onready var animation_tree: AnimationTree = $Model/AnimationTree

@export_category("Health Options")
@export var hp := 10.0:
	set(v):
		hp = v
		$HealthBar3d.update_healthbar(v)

@export var max_hp := 10.0:
	set(v):
		max_hp = v
		$HealthBar3d.set_max_value(v)

#region movement
@export_category("Movement Options")
@export var speed := 5.0
@export var rotation_speed := 12.0
@export var jump_velocity := 4.5
@export var dash_speed := 10.0
@export var dash_length := 5.0
@export var dash_cooldown := 0.3
@export var is_dash_hold := false
@export var is_mid_air_movement := true
@export var is_wall_slide := false
@export var wall_slide_velocity := -0.5

var is_dash_ready := true
var last_movement_direction := Vector3.FORWARD:
	set(v):
		last_movement_direction = v
		_look_direction = v
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

func look_forward(weight: float) -> void:
	if is_aiming(): return
	var target_angle := Vector3.FORWARD.signed_angle_to(_look_direction, Vector3.UP)
	model.rotation.y = lerp_angle(model.rotation.y, target_angle, weight)

func _do_dash() -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var dash_direction := (
		Vector3(input_vector.x, 0, input_vector.y).rotated(Vector3.UP, twist_pivot.rotation.y) if is_on_floor() and input_vector else
		Vector3.FORWARD.rotated(Vector3.UP, model.rotation.y)
	).normalized()
	
	var direction = dash_direction * dash_speed
	velocity.x = direction.x
	velocity.z = direction.z
	velocity.y = 0
	last_movement_direction = dash_direction

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
		last_movement_direction = Vector3(input_direction.x, 0, input_direction.y).rotated(Vector3.UP, twist_pivot.rotation.y) * input_magnitude * speed
		velocity.x = last_movement_direction.x
		velocity.z = last_movement_direction.z
		
	look_forward(rotation_speed * delta)

func _do_fall(delta: float) -> void:
	velocity += get_gravity() * delta
#endregion 

#region aiming
func is_aiming() -> bool: return Input.is_action_pressed("aim")

func _handle_aim() -> void:
	if Input.is_action_just_pressed("aim"):
		_do_aim_start()
	elif Input.is_action_just_released("aim"):
		_do_aim_end()

func _do_aim_start() -> void:
	aim_camera.current = true
	aim_camera.process_mode = Node.PROCESS_MODE_INHERIT
	free_camera.process_mode = Node.PROCESS_MODE_DISABLED
	rotation.y = twist_pivot.rotation.y
	model.rotation = Vector3.ZERO

func _do_aim_end() -> void:
	free_camera.current = true
	free_camera.process_mode = Node.PROCESS_MODE_INHERIT
	aim_camera.process_mode = Node.PROCESS_MODE_DISABLED
	rotation.y = 0
	model.rotation = Vector3.ZERO
		
#endregion
