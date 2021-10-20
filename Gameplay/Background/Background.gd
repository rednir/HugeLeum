extends Node2D

export var speed = 20

func _process(delta):
	$ParallaxBackground.scroll_offset -= Vector2(speed * delta, 0)
