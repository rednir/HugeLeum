extends KinematicBody2D


export var move_speed = 150
export var bounce_height = 200
export var weight = 5

var disappear = false
var velocity = Vector2(-move_speed, 0)
var collision_info

func _ready():
	pass


func _process(delta):
	collision_info = move_and_collide(velocity * delta)

	if collision_info and "Ground" in collision_info.collider.name:
		velocity.y = -bounce_height

	velocity.y += weight
	velocity.x += -50 if disappear else 0
	