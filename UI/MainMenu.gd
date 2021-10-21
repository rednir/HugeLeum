extends Control


onready var animation_player = $AnimationPlayer


func _ready():
	$PlayButton.connect("pressed", self, "on_play_button_pressed")


func on_play_button_pressed():
	animation_player.play("out")
	animation_player.connect("animation_finished", self, "play", ["out"])
	

func play(_a, _b):
	get_tree().change_scene("Gameplay/Game.tscn")
