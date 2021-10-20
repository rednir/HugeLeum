extends Node2D


var scroll_speed = 50

onready var camera = $Camera


func _ready():
	print("game ready")
	camera.set_scroll_speed(scroll_speed)


func _process(delta):
	pass
