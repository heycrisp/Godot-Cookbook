extends Camera3D

var tpc: ThirdPersonController

func _ready() -> void:
	await owner.ready
	tpc = owner as ThirdPersonController
	assert(tpc != null, "Invalid root node detected")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass