extends StaticBody2D

export var move_speed = 100

var disappear = false
var extra_movement = 0


func _process(delta):
	extra_movement += 38 if disappear else 0
	position.x -= (move_speed + extra_movement) * delta
	if extra_movement > 3400:
		queue_free()
