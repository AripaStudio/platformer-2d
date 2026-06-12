class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 900.0
const WALL_SLIDE_SPEED = 100.0

var max_jumps: int = 2
var jump_count: int = 0
var can_dash: bool = true
var is_dashing: bool = false
var dash_duration: float = 0.2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	move_and_slide()


func _handle_sprite_flip(direction: float) -> void:
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
