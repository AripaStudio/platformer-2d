class_name PlayerStateMachine
extends Node

@export var initial_state: Node

var current_state: PlayerState
var states: Dictionary = { }


func _ready() -> void:
	for child in get_children():
		if child is PlayerState:
			var state_node: PlayerState = child as PlayerState
			states[state_node.name.to_lower()] = state_node
			state_node.state_machine = self
			state_node.player = get_parent() as Player
	if initial_state:
		current_state = initial_state as PlayerState
		call_deferred("_start_initial_state")


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func transition_to(target_state_name: String) -> void:
	var target_state = states.get(target_state_name.to_lower())
	if not target_state or target_state == current_state:
		return
	current_state.exit()
	current_state = target_state
	current_state.enter()


func _start_initial_state() -> void:
	if current_state:
		current_state.enter()
