extends CenterContainer

onready var panel = $Panel
onready var fade_node = $Fade
onready var fade = $Fade/AnimationPlayer
onready var play_button = $Panel/ButtonsContainer/PlayButton
onready var cancel_button = $Panel/ButtonsContainer/CancelButton

# TODO: own scene for custom game.
var game_scene = preload("res://Gameplay/Game.tscn")
var game: Node2D


func _ready():
	play_button.connect("pressed", self, "on_play_button_pressed")
	cancel_button.connect("pressed", self, "on_cancel_button_pressed")
	new_game_instance()


func new_game_instance():
	game = game_scene.instance()
	game.queue_free_on_death = true
	game.connect("tree_exited", self, "on_game_exit")


func on_play_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "on_play_animation_finished", ["in"])


func on_cancel_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "on_cancel_animation_finished", ["in"])


func on_game_exit():
	new_game_instance()
	panel.visible = true
	fade_node.offset = Vector2(0, 0)
	fade.play("out")


func on_play_animation_finished(name, _b):
	fade.disconnect("animation_finished", self, "on_play_animation_finished")
	if name == "in":
		add_child(game)
		panel.visible = false
		fade_node.offset = Vector2(10000, 0)


func on_cancel_animation_finished(_a, _b):
	get_tree().change_scene("res://UI/MainMenu.tscn")
