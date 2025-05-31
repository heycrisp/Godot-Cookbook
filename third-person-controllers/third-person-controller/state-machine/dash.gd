extends ThirdPersonControllerState

@onready var duration: Timer = $Duration
@onready var cooldown: Timer = $Cooldown

func _enter(_p, _d = {}) -> void:
	tpc._do_dash()
	duration.start(tpc.dash_length / tpc.dash_speed)
	tpc.is_dash_ready = false

func _exit() -> void:
	cooldown.start(tpc.dash_cooldown)

func _do_physics_process(_d) -> void:
	tpc.move_and_slide()

func _on_duration_timeout() -> void:
	finished.emit(IWR)

func _on_cooldown_timeout() -> void:
	tpc.is_dash_ready = true
