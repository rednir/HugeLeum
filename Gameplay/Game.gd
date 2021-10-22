extends Node2D

const game_environments = [GameEnvironment.PLAINS, GameEnvironment.DESERT]

onready var camera = $Camera
onready var ground = $Camera/Ground
onready var background = $Background

export var env_change_interval = 20
export var scroll_speed = 120
export var scroll_speed_change = 75
export var max_scroll_speed = 500

var current_environment_index = 0
var env_change_timer = 0


func _ready():
	camera.set_scroll_speed(scroll_speed)


func _process(delta):
	env_change_timer += delta

	if env_change_timer > env_change_interval:
		next_environment()


func next_environment():
	current_environment_index += 1 if current_environment_index == 0 else -1
	ground.change_environment(game_environments[current_environment_index])
	background.change_environment(game_environments[current_environment_index])

	scroll_speed += scroll_speed_change
	camera.set_scroll_speed(min(scroll_speed, max_scroll_speed))

	env_change_timer = 0
