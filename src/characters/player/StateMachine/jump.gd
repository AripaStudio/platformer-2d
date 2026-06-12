extends PlayerState


func enter() -> void:
	player.animated_sprite_2d.play("jump")
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		player.jump_count = 1


func physics_update(delta: float) -> void:
	player.velocity += player.get_gravity() * delta
	var direction = handle_horizontal_movement()
	if player.is_on_wall() and not player.is_on_floor() and player.velocity.y > 0:
		state_machine.transition_to("wallslide")
		return
	if Input.is_action_just_pressed("jump") and player.jump_count < player.max_jumps:
		player.velocity.y = player.JUMP_VELOCITY
		player.jump_count += 1
		player.animated_sprite_2d.play("double_jump")
		return
	if player.is_on_floor():
		player.jump_count = 0
		if direction != 0:
			state_machine.transition_to("walk")
		else:
			state_machine.transition_to("idle")
		return
	if Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("dash")
		return
