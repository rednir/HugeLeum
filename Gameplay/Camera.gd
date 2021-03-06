extends Camera2D

export var initial_delay = 1.5

var scroll_speed = 0
var elapsed_time = 0


func _ready():
	pass


func _process(delta):
	if elapsed_time < initial_delay:
		elapsed_time += delta
		return
	
	translate(Vector2(scroll_speed * delta, 0))


func set_scroll_speed(new_scroll_speed):
	scroll_speed = new_scroll_speed

