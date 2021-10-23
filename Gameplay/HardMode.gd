extends Node2D


onready var game = $Game


func _ready():
	game.player.max_lives = 1
	game.player.lives = 1
	game.heart_display.heart_count = 1
	game.heart_display.max_hearts = 1
