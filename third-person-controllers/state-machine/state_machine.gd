class_name StateMachine extends Node

@export var initial_state: State
@export var is_debug := false

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	
	await owner.ready
	state._enter("")

func _unhandled_input(event: InputEvent) -> void:
	state._do_unhandled_input(event)

func _process(delta: float) -> void:
	state._do_process(delta)

func _physics_process(delta: float) -> void:
	state._do_physics_process(delta)

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if is_debug:
		print_debug("Tranisitioning to %s from %s" % [target_state_path, state.name])

	if not has_node(target_state_path):
		printerr("%s: Trying to transition to state %s but it does not exist." % [owner.name, target_state_path])
		return

	var previous_state_path := state.name
	state._exit()
	state = get_node(target_state_path)
	state._enter(previous_state_path, data)
