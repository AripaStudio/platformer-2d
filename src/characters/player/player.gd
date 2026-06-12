extends CharacterBody2D

enum PlayerState { IDLE, WALK, JUMP, DOUBLE_JUMP, DASH, WALL_SLIDE }

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 900.0
const WALL_SLIDE_SPEED = 100.0

var max_jumps: int = 2
var jump_count: int = 0
var can_dash: bool = true
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_duration: float = 0.2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if is_dashing:
		_process_dash(delta)
		return
	_apply_gravity(delta)
	_handle_wall_slide()
	_handle_jump()

	var direction := Input.get_axis("move_left", "move_right")
	_handle_horizontal_movement(direction)
	_handle_dash_initiation(direction)
	move_and_slide()
	_update_character_state(direction)


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func _handle_wall_slide() -> void:
	if is_on_wall() and not is_on_floor() and velocity.y > 0:
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)


func _handle_jump() -> void:
	if is_on_floor() or is_on_wall():
		jump_count = 0
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count += 1
		elif is_on_wall():
			velocity.y = JUMP_VELOCITY
			var wall_normal = get_wall_normal()
			velocity.x = wall_normal.x * SPEED * 1.5
			jump_count = 1
		elif jump_count < max_jumps:
			velocity.y = JUMP_VELOCITY
			jump_count += 1


func _handle_horizontal_movement(direction: float) -> void:
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction != 0 and is_on_floor():
		can_dash = true


func _handle_dash_initiation(direction: float) -> void:
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		dash_timer = dash_duration

		var dash_dir = direction
		if dash_dir == 0:
			dash_dir = -1.0 if animated_sprite_2d.flip_h else 1.0

		velocity.x = dash_dir * DASH_SPEED
		velocity.y = 0


func _process_dash(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0:
		is_dashing = false
		velocity.x = 0
	move_and_slide()


func _update_character_state(direction: float) -> void:
	var current_state := PlayerState.IDLE

	if is_dashing:
		current_state = PlayerState.DASH
	elif is_on_wall() and not is_on_floor() and velocity.y > 0:
		current_state = PlayerState.WALL_SLIDE
	elif not is_on_floor():
		if jump_count > 1:
			current_state = PlayerState.DOUBLE_JUMP
		else:
			current_state = PlayerState.JUMP
	elif velocity.x != 0:
		current_state = PlayerState.WALK

	_start_animation(current_state)
	_handle_sprite_flip(direction)


func _start_animation(state: PlayerState) -> void:
	match state:
		PlayerState.IDLE:
			if animated_sprite_2d.sprite_frames.has_animation("idle"):
				animated_sprite_2d.play("idle")
		PlayerState.WALK:
			if animated_sprite_2d.sprite_frames.has_animation("walk"):
				animated_sprite_2d.play("walk")
		PlayerState.JUMP:
			if animated_sprite_2d.sprite_frames.has_animation("jump"):
				animated_sprite_2d.play("jump")
		PlayerState.DOUBLE_JUMP:
			if animated_sprite_2d.sprite_frames.has_animation("double_jump"):
				animated_sprite_2d.play("double_jump")
		PlayerState.DASH:
			if animated_sprite_2d.sprite_frames.has_animation("dash"):
				animated_sprite_2d.play("dash")
		PlayerState.WALL_SLIDE:
			if animated_sprite_2d.sprite_frames.has_animation("wall_slide"):
				animated_sprite_2d.play("wall_slide")


func _handle_sprite_flip(direction: float) -> void:
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
