extends Node2D


var scroll_speed = 100

onready var camera = $Camera


func _ready():
	camera.set_scroll_speed(scroll_speed)


func _process(delta):
	pass
