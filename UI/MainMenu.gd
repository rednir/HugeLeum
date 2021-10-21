extends Control


onready var fade = $Fade


func _ready():
	$PlayButton.connect("pressed", self, "on_play_button_pressed")


func on_play_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "play", ["in"])
	

func play(_a, _b):
	get_tree().change_scene("Gameplay/Game.tscn")
