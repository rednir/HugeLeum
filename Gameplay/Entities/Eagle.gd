extends KinematicBody2D

export var move_speed = 100

var disappear = false
var extra_movement = 0


func _process(delta):
	extra_movement += 19 if disappear else 0
	position.x -= (extra_movement + move_speed) * delta
	if extra_movement > 3400:
		queue_free()
