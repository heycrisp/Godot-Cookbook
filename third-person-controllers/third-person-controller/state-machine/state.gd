class_name ThirdPersonControllerState extends State

const IWR := "IdleWalkRun"
const JUMP := "Jump"
const FALL := "Fall"

var tpc: ThirdPersonController

func _ready() -> void:
	await owner.ready
	tpc = owner as ThirdPersonController
	assert(tpc != null, "The ThirdPersonControllerState type must be a direct child of a ThirdPersonController.")