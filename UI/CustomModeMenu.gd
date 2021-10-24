extends CenterContainer


onready var panel = $Panel
onready var fade_node = $Fade
onready var fade = $Fade/AnimationPlayer
onready var play_button = $Panel/ButtonsContainer/PlayButton
onready var cancel_button = $Panel/ButtonsContainer/CancelButton


# TODO: own scene for custom game.
var game_scene = preload("res://Gameplay/Game.tscn")
var game = game_scene.instance()


func _ready():
	play_button.connect("pressed", self, "on_play_button_pressed")
	cancel_button.connect("pressed", self, "on_cancel_button_pressed")


func on_play_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "on_play_animation_finished", ["in"])


func on_cancel_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "on_cancel_animation_finished", ["in"])


func on_play_animation_finished(_a, _b):
	add_child(game)
	panel.visible = false
	fade_node.offset = Vector2(10000, 0)


func on_cancel_animation_finished(_a, _b):
	get_tree().change_scene("res://UI/MainMenu.tscn")
