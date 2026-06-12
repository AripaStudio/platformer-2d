extends PlayerState


func enter() -> void:
	if not player:
		return
	player.animated_sprite_2d.play("idle")
	player.velocity.x = 0
	player.can_dash = true


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("jump")
		return
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.transition_to("walk")
		return
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("jump")
		return
	if Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("dash")
		return
