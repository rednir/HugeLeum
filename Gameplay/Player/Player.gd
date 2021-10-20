extends KinematicBody2D


export var weight = 20
export var jump_height = 300
export var additional_jump_force = 30 # when jump key held
export var max_jump_key_hold_time = 0.15

var y_velocity = 0
var jumping = true
var jump_key_held = false
var jump_key_hold_time = 0
var collision_info = null


func _ready():
	pass


func _input(event):
	if event.is_action_pressed("jump") and not jumping:
		y_velocity -= jump_height
		jumping = true
		jump_key_held = true
	
	if event.is_action_released("jump") and jumping:
		jump_key_held = false
		jump_key_hold_time = 0


func _process(delta):
	if jump_key_held and jump_key_hold_time < max_jump_key_hold_time:
		jump_key_hold_time += delta
		print("adding to jump")
	elif jump_key_hold_time > max_jump_key_hold_time:
		jump_key_held = false
		print("set to false")

	if jumping:
		if jump_key_held:
			y_velocity -= additional_jump_force
		y_velocity += weight
		collision_info = move_and_collide(Vector2(0, y_velocity * delta))
		if collision_info:
			jumping = false
			y_velocity = 0


# func cut_jump_height(): # if the player releases jump early
	# if jumping:
	# 	if jump_key_hold_time < 0.2:
	# 		y_velocity = jump_height_min
	# 	elif jump_key_hold_time < 0.6:
	# 		y_velocity = (jump_height_min + (jump_height_max - jump_height_min)) * (jump_key_hold_time / 0.4)

	# if jump_key_held and -y_velocity < max_jump_height:
	# 	y_velocity -= jump_boost_when_held
	# 	print(y_velocity)
	# elif -y_velocity > max_jump_height:
	# 	jump_key_held = false
