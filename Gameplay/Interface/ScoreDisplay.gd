extends Sprite

onready var label = $Label

var score = 0


func _process(delta):
	label.text = str(score) + "m"
