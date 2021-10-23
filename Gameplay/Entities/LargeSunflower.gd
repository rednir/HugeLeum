extends StaticBody2D

var disappear = false
var extra_movement = 0


func _process(delta):
	extra_movement += 19 if disappear else 0
	position.x -= (extra_movement + extra_movement) * delta
	if extra_movement > 2000:
		queue_free()