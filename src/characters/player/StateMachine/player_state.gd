class_name PlayerState
extends Node

var state_machine: PlayerStateMachine
var player: Player


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func handle_horizontal_movement() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction != 0:
		player.velocity.x = direction * player.SPEED
		player._handle_sprite_flip(direction)
	return direction
