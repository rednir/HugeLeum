extends Control


func _ready():
	$PlayButton.connect("pressed", self, "on_play_button_pressed")


func on_play_button_pressed():
	get_tree().change_scene("Gameplay/Game.tscn")
