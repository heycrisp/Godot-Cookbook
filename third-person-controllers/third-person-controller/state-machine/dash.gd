extends ThirdPersonControllerState

@onready var duration: Timer = $Duration
@onready var cooldown: Timer = $Cooldown

func _enter(_p, _d = {}) -> void:
	# print("Dash _enter")
	tpc._do_dash()
	duration.start(tpc.dash_length / tpc.dash_speed)
	tpc.is_dash_ready = false
	super (_p, _d)

func _exit() -> void:
	# print("Dash _exit")
	cooldown.start(tpc.dash_cooldown)

func _do_physics_process(_d) -> void:
	# print("Dash _do_physics_process")
	tpc.move_and_slide()

func _on_duration_timeout() -> void:
	finished.emit(IWR)

func _on_cooldown_timeout() -> void:
	tpc.is_dash_ready = true
