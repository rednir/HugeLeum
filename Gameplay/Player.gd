extends KinematicBody2D


const weight = 5
const jump_height = 20

var y_velocity = 0
var jumping = true
var collision_info = null


func _ready():
	pass


func _input(event):
	if event.is_action_pressed("jump") and not jumping:
		y_velocity -= jump_height
		jumping = true


func _process(delta):
	if jumping:
		y_velocity += weight
		collision_info = move_and_collide(Vector2(0, y_velocity * delta))
		if collision_info:
			print("collision")
			jumping = false

