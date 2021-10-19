extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayButton.connect("pressed", self, "on_play_button_pressed")

func on_play_button_pressed():
	if get_tree().change_scene("Gameplay/Game.tscn") != OK:
		pass # handle error

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
