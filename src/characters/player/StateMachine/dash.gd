extends PlayerState

var _dash_timer: float = 0.0


func enter() -> void:
	player.animated_sprite_2d.play("dash")
	player.can_dash = false
	player.velocity.y = 0
	_dash_timer = 0.2
	var dash_dir = Input.get_axis("move_left", "move_right")
	if dash_dir == 0:
		dash_dir = -1.0 if player.animated_sprite_2d.flip_h else 1.0
	player.velocity.x = dash_dir * player.DASH_SPEED


func physics_update(delta: float) -> void:
	_dash_timer -= delta
	if _dash_timer <= 0.0:
		if player.is_on_floor():
			var direction = Input.get_axis("move_left", "move_right")
			if direction != 0:
				state_machine.transition_to("walk")
			else:
				state_machine.transition_to("idle")
		else:
			state_machine.transition_to("jump")
		return


func exit() -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
