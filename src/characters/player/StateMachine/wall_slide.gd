extends PlayerState


func enter() -> void:
	player.animated_sprite_2d.play("wall_slide")
	player.velocity.y = min(player.velocity.y, player.WALL_SLIDE_SPEED)
	player.can_dash = true


func physics_update(delta: float) -> void:
	if player.is_on_floor():
		state_machine.transition_to("idle")
		return
	if not player.is_on_wall():
		state_machine.transition_to("jump")
		return
	var wall_normal = player.get_wall_normal()
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.y = min(player.velocity.y + player.get_gravity().y * delta, player.WALL_SLIDE_SPEED)
	if Input.is_action_just_pressed("jump"):
		player.velocity.x = wall_normal.x * player.SPEED * 1.5
		player.velocity.y = player.JUMP_VELOCITY
		player.jump_count = 1
		state_machine.transition_to("jump")
		return
	if direction != 0:
		if sign(direction) != sign(wall_normal.x):
			player.velocity.x = direction * 50.0
		else:
			state_machine.transition_to("jump")
			return
	else:
		player.velocity.x = -wall_normal.x * 50.0
