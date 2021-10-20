extends KinematicBody2D


export var horizontal_move_speed = 400
export var horizontal_move_force = 50
export var weight = 20
export var jump_height = 300
export var additional_jump_force = 30 # when jump key held
export var max_jump_key_hold_time = 0.15

var velocity = Vector2(0, 0)
var jumping = true
var jump_key_held = false
var jump_key_hold_time = 0
var collision_info = null


func _ready():
	pass


func _input(event):
	if event.is_action_pressed("jump") and not jumping:
		velocity.y -= jump_height
		jumping = true
		jump_key_held = true
	
	if event.is_action_released("jump") and jumping:
		jump_key_held = false
		jump_key_hold_time = 0


func _process(delta):
	if Input.is_action_pressed("move_left"):
		if velocity.x > -horizontal_move_speed:
			velocity.x -= horizontal_move_force
	else:
		if velocity.x < 0:
			velocity.x += horizontal_move_force

	if Input.is_action_pressed("move_right"):
		if velocity.x < horizontal_move_speed:
			velocity.x += horizontal_move_force
	else:
		if velocity.x > 0:
			velocity.x -= horizontal_move_force

	if jump_key_held and jump_key_hold_time < max_jump_key_hold_time:
		jump_key_hold_time += delta
	elif jump_key_hold_time > max_jump_key_hold_time:
		jump_key_held = false

	if jumping:
		if jump_key_held:
			velocity.y -= additional_jump_force
		velocity.y += weight

	collision_info = move_and_collide(Vector2(velocity.x * delta, velocity.y * delta))
	if collision_info:
		jumping = false
		velocity.y = 0
