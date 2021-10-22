extends Control


onready var fade = $Fade
onready var ground = $Ground
onready var bg = $Background
onready var ground_parallax = $Ground/ParallaxBackground
onready var bg_parallax = $Background/ParallaxBackground


func _ready():
	$PlayButton.connect("pressed", self, "on_play_button_pressed")

	randomize()
	var env = randi() % GameEnvironment.list.size()
	ground.change_environment(env)
	bg.change_environment(env)


func on_play_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "play", ["in"])
	

func _process(delta):
	ground_parallax.scroll_offset -= Vector2(20, 0) * delta
	bg_parallax.scroll_offset -= Vector2(20, 0) * delta


func play(_a, _b):
	get_tree().change_scene("Gameplay/Game.tscn")
