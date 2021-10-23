extends StaticBody2D


export var move_speed = 100


func _ready():
	pass


func _process(delta):
	position.x -= move_speed * delta
