extends Node2D

onready var game_overlay_content = $GameOverlay/Content
onready var interface = $Interface
onready var panel = $Interface/Panel
onready var fade = $Interface/Fade/AnimationPlayer
onready var fade_node = $Interface/Fade
onready var play_button = $Interface/Panel/ButtonsContainer/PlayButton
onready var cancel_button = $Interface/Panel/ButtonsContainer/CancelButton

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
	game.connect("ready", self, "on_game_ready")


func on_play_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "on_play_animation_finished", ["in"])


func on_cancel_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "on_cancel_animation_finished", ["in"])


func on_game_exit():
	new_game_instance()
	game_overlay_content.visible = false
	interface.visible = true
	fade_node.scale = Vector2(1, 1)
	fade.play("out")


func on_play_animation_finished(name, _b):
	fade.disconnect("animation_finished", self, "on_play_animation_finished")
	if name == "in":
		add_child(game)
		game_overlay_content.visible = true
		interface.visible = false
		fade_node.scale = Vector2(0, 0)


func on_game_ready():
	# Scroll Speed
	game.scroll_speed = $"Interface/Panel/TabContainer/Scroll Speed/Initial/Slider".value
	game.camera.set_scroll_speed(game.scroll_speed)
	game.max_scroll_speed = $"Interface/Panel/TabContainer/Scroll Speed/Max/Slider".value
	game.scroll_speed_change = $"Interface/Panel/TabContainer/Scroll Speed/ChangeAmount/Slider".value
	game.env_change_interval = $"Interface/Panel/TabContainer/Scroll Speed/InitialTimeBeforeSpeedup/Slider".value
	game.env_change_time_increment = $"Interface/Panel/TabContainer/Scroll Speed/SpeedupIncrement/Slider".value

	# Player
	game.player.horizontal_move_speed = $"Interface/Panel/TabContainer/Player/InitialSpeed/Slider".value
	game.player.max_horizontal_move_speed = $"Interface/Panel/TabContainer/Player/MaxSpeed/Slider".value
	game.player_horizontal_movement_rate_increase = $"Interface/Panel/TabContainer/Player/SpeedIncreaseRate/Slider".value
	game.player.jump_power = $"Interface/Panel/TabContainer/Player/JumpPower/Slider".value
	game.player.weight = $"Interface/Panel/TabContainer/Player/Weight/Slider".value

	game.player.lives = $"Interface/Panel/TabContainer/Player/InitialLives/SpinBox".value
	game.player.max_lives = $"Interface/Panel/TabContainer/Player/MaxLives/SpinBox".value
	game.heart_display.max_hearts = game.player.max_lives
	game.heart_display.heart_count = game.player.lives


func on_cancel_animation_finished(_a, _b):
	get_tree().change_scene("res://UI/MainMenu.tscn")
