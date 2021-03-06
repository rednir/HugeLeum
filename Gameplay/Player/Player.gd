extends KinematicBody2D

signal death

onready var animated_sprite = $AnimatedSprite
onready var shield = $Shield

onready var animation_player = $AnimationPlayer
onready var life_lost_audio = $LifeLostAudio
onready var pickup_audio = $PickupAudio
onready var jump_audio = $JumpAudio
onready var death_audio = $DeathAudio

export var horizontal_move_speed = 31000
export var max_horizontal_move_speed = 55000
export var slowdown_speed = 300

export var weight = 4500
export var jump_power = 40000
export var max_y_vel = 1000
export var max_time_airborne = 0.2

export var initial_knock_back_velocity = Vector2(-400, -1300)
export var max_knock_back_time = 0.18

export var max_lives = 2
export var lives = 2

var shielded = false
var time_shielded_for = 0

var velocity = Vector2(0, 0)

var knocked_back = false
var knock_back_velocity = Vector2(0, 0)
var time_knocked_back_for = 0

var iframe_time_left = 0

var already_jumped_this_key_press = false

var time_airborne = 0
var collision_info = null

var total_times_jumped = 0
var num_of_powerups_collected = 0


func _ready():
	pass


func _physics_process(delta):
	collision_info = move_and_collide(velocity * delta)

	check_collisions()

	if lives < 1:
		death()
		return

	update_status_effects(delta)

	update_movement_y(delta)
	update_movement_x(delta)

	update_animation(delta)

	collision_info = null


func death():
	set_physics_process(false)
	animated_sprite.play("dying")
	animation_player.play("death")
	death_audio.play()
	emit_signal("death")


func check_collisions():
	if collision_info:
		if "HealthPickup" in collision_info.collider.name:  # weird jank where sometimes the health pickup is called "@6HealthPickup@6"
			pickup_audio.play()
			collision_info.collider.on_pickup()
			num_of_powerups_collected += 1
			if not lives >= max_lives:
				lives += 1
		elif "ShieldPowerup" in collision_info.collider.name:
			pickup_audio.play()
			collision_info.collider.on_pickup()
			shielded = true
			shield.visible = true
			time_shielded_for = 0
			num_of_powerups_collected += 1
		elif collision_info.collider.is_in_group("damaging"):
			if not (shielded or knocked_back or iframe_time_left > 0):
				animation_player.play("life-lost")
				life_lost_audio.play()
				lives -= 1
				iframe_time_left = 0.8
			if not knocked_back:
				knocked_back = true
				velocity = initial_knock_back_velocity \
					if collision_info.normal.x <= 0 \
					else Vector2(-initial_knock_back_velocity.x, initial_knock_back_velocity.y)
		elif collision_info.collider.is_in_group("insta-kill"):
			lives = 0


func update_status_effects(delta):
	time_shielded_for += delta if shielded else 0
	iframe_time_left = iframe_time_left - delta if iframe_time_left > 0 else 0

	if time_shielded_for > 7:
		shielded = false
		shield.visible = false
		time_shielded_for = 0

	if knocked_back:
		time_knocked_back_for += delta
		if time_knocked_back_for > max_knock_back_time:
			knocked_back = false
			time_knocked_back_for = 0


func update_movement_x(delta):
	horizontal_move_speed = min(max_horizontal_move_speed, horizontal_move_speed)

	if not knocked_back and collision_info and collision_info.normal.y != -1:
		velocity.x = 0
	elif not knocked_back and Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		velocity.x = min(velocity.x + slowdown_speed, horizontal_move_speed * delta)
	elif not knocked_back and Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		velocity.x = max(velocity.x - slowdown_speed, -horizontal_move_speed * delta)
	elif velocity.x != 0:
		if abs(velocity.x) - slowdown_speed * 6 * delta < 0:
			# Player is almost at a complete halt, so just set to 0.
			velocity.x = 0
		else:
			# Gradually slowdown player velocity.
			velocity.x += (
				-slowdown_speed * 6 * delta
				if velocity.x > 0
				else slowdown_speed * 6 * delta
			)


func update_movement_y(delta):
	# Start applying weight if been in air for too long.
	velocity.y += weight * delta if time_airborne >= max_time_airborne else 1

	if not Input.is_action_pressed("jump"):
		already_jumped_this_key_press = false

	if collision_info and collision_info.collider.is_in_group("collidable"):
		time_airborne = 0
		if Input.is_action_pressed("jump") and not already_jumped_this_key_press:
			velocity.y = max(velocity.y - jump_power, -jump_power) * delta
			already_jumped_this_key_press = true
			total_times_jumped += 1
			jump_audio.play()
		elif collision_info.normal.y != -1:
			velocity.y += weight * delta if velocity.y < max_y_vel else 0
		else:
			velocity.y = 0
	else:
		# If player stops holding jump, start applying weight by maxing out `time_airborne`
		time_airborne = (
			time_airborne + delta
			if Input.is_action_pressed("jump")
			else max_time_airborne
		)


func update_animation(delta):
	if velocity.y > weight * (delta * 2):
		animated_sprite.play("falling")
		animated_sprite.flip_h = false if velocity.x >= 0 else true
	elif velocity.x > 0:
		animated_sprite.play("moving")
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.play("moving")
		animated_sprite.flip_h = true
	else:
		animated_sprite.play("still")
