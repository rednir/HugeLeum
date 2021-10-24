extends Control


onready var fade = $Fade/AnimationPlayer
onready var ground = $Ground
onready var bg = $Background
onready var play_button = $PlayButton
onready var hard_mode_button = $HardModeButton
onready var custom_mode_button = $CustomModeButton
onready var ground_parallax = $Ground/ParallaxBackground
onready var bg_parallax = $Background/ParallaxBackground


func _ready():
	play_button.connect("pressed", self, "on_play_button_pressed")
	hard_mode_button.connect("toggled", self, "on_hard_mode_toggled")
	custom_mode_button.connect("toggled", self, "on_custom_mode_toggled")

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


func on_hard_mode_toggled(button_pressed: bool):
	play_button.text = "Hard Mode" if button_pressed else "Play"
	custom_mode_button.disabled = button_pressed


func on_custom_mode_toggled(button_pressed: bool):
	play_button.text = "Custom Mode" if button_pressed else "Play"
	hard_mode_button.disabled = button_pressed


func play(_a, _b):
	if custom_mode_button.pressed:
		get_tree().change_scene("res://UI/CustomModeMenu.tscn")
	elif hard_mode_button.pressed:
		get_tree().change_scene("res://Gameplay/HardMode.tscn")
	else:
		get_tree().change_scene("res://Gameplay/Game.tscn")
	
		
