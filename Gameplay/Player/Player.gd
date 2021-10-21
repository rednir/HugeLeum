extends KinematicBody2D


export var starting_lives = 2
export var horizontal_move_speed = 570
export var slowdown_speed = 25
export var weight = 35
export var jump_height = 800
export var max_time_airborne = 0.2

var lives = starting_lives

var velocity = Vector2(0, 0)

var time_airborne = 0
var collision_info = null


func _ready():
	pass


func _process(delta):
	collision_info = move_and_collide(Vector2(velocity.x * delta, velocity.y * delta))

	if collision_info and collision_info.collider.name == "HealthPickup":
		collision_info.collider.on_pickup()
		lives += 1
		print("life added")

	if collision_info and (collision_info.collider.name == "Ground1" or collision_info.collider.name == "Ground2"):
		time_airborne = 0
		velocity.y = (velocity.y - jump_height) if Input.is_action_just_pressed("jump") else 0
	else:
		# If player stops holding jump, start applying weight by maxing out `time_airborne`
		time_airborne = max_time_airborne if Input.is_action_just_released("jump") else (time_airborne + delta)

	# Start applying weight if been in air for too long.
	velocity.y += weight if time_airborne > max_time_airborne else 1

	if Input.is_action_pressed("move_left"):
		velocity.x = -horizontal_move_speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = horizontal_move_speed
	elif velocity.x != 0:
		if abs(velocity.x) - slowdown_speed < 0:
			# Player is almost at a complete halt, so just set to 0.
			velocity.x = 0
		else:
			# Gradually slowdown player velocity.
			velocity.x += -slowdown_speed if velocity.x > 0 else slowdown_speed
