extends KinematicBody2D

export var starting_lives = 2

export var horizontal_move_speed = 570
export var slowdown_speed = 25

export var weight = 35
export var jump_height = 800
export var max_time_airborne = 0.2

export var initial_knock_back_velocity = Vector2(-800, -300)
export var max_knock_back_time = 0.3

var lives = starting_lives

var shielded = false
var time_shielded_for = 0

var velocity = Vector2(0, 0)

var knocked_back = false
var knock_back_velocity = Vector2(0, 0)
var time_knocked_back_for = 0

var time_airborne = 0
var collision_info = null


func _ready():
	pass


func _process(delta):
	collision_info = move_and_collide(velocity * delta)

	check_collisions()

	if lives < 1:
		print("oh no you died")

	update_status_effects(delta)

	update_movement_y(delta)
	update_movement_x()

	collision_info = null


func check_collisions():
	if collision_info:
		if "HealthPickup" in collision_info.collider.name: # weird jank where sometimes the health pickup is called "@6HealthPickup@6"
			collision_info.collider.on_pickup()
			lives += 1
			print("life added")
		elif "ShieldPowerup" in collision_info.collider.name:
			collision_info.collider.on_pickup()
			shielded = true
			time_shielded_for = 0
			print("shield picked up")
		elif collision_info.collider.is_in_group("damaging"):
			if not shielded and not knocked_back:
				lives -= 1
			if not knocked_back:
				knocked_back = true
				velocity = initial_knock_back_velocity


func update_status_effects(delta):
	if shielded:
		time_shielded_for += delta

	if time_shielded_for > 3:
		shielded = false
		time_shielded_for = 0

	if knocked_back:
		time_knocked_back_for += delta
		if time_knocked_back_for > max_knock_back_time:
			knocked_back = false
			time_knocked_back_for = 0


func update_movement_x():
	# Start applying weight if been in air for too long.
	velocity.y += weight if time_airborne > max_time_airborne else 1

	if not knocked_back and Input.is_action_pressed("move_left"):
		velocity.x = -horizontal_move_speed
	elif not knocked_back and Input.is_action_pressed("move_right"):
		velocity.x = horizontal_move_speed
	elif velocity.x != 0:
		if abs(velocity.x) - slowdown_speed < 0:
			# Player is almost at a complete halt, so just set to 0.
			velocity.x = 0
		else:
			# Gradually slowdown player velocity.
			if not knocked_back:
				velocity.x += -slowdown_speed if velocity.x > 0 else slowdown_speed
			else:
				velocity.x += 5


func update_movement_y(delta):
	if collision_info and collision_info.collider.is_in_group("collidable"):
		time_airborne = 0
		velocity.y = (velocity.y - jump_height) if Input.is_action_just_pressed("jump") else 0
	else:
		# If player stops holding jump, start applying weight by maxing out `time_airborne`
		time_airborne = (
			max_time_airborne
			if Input.is_action_just_released("jump")
			else (time_airborne + delta)
		)
