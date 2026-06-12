extends PlayerState


func enter() -> void:
	player.animated_sprite_2d.play("walk")
	player.can_dash = true


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("jump")
		return
	var direction = Input.get_axis("move_left", "move_right")
	if direction == 0:
		state_machine.transition_to("idle")
		return
	handle_horizontal_movement()
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("jump")
