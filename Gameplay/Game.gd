extends Node2D


const game_environments = [GameEnvironment.PLAINS, GameEnvironment.DESERT]

onready var camera = $Camera
onready var ground = $Camera/Ground
onready var background = $Background


const plains_entity_patterns = [
	preload("res://Gameplay/EntityPatterns/Pattern1.tscn"), 
	preload("res://Gameplay/EntityPatterns/Pattern2.tscn"), 
	preload("res://Gameplay/EntityPatterns/Pattern3.tscn"), 
	preload("res://Gameplay/EntityPatterns/Pattern4.tscn")
]

export var env_change_interval = 20
export var env_change_timer = 0

var scroll_speed = 100
var total_distance_travelled = 0
var distance_travelled_since_pattern_instance = 0

var current_environment_index = 0


func _ready():
	camera.set_scroll_speed(scroll_speed)

	var starting_scene = plains_entity_patterns[randi() % plains_entity_patterns.size()].instance()
	add_child(starting_scene)

	var next_scene = plains_entity_patterns[randi() % plains_entity_patterns.size()].instance()
	add_child(next_scene)
	for child in next_scene.get_children():
		child.position.x += 1024


func _process(delta):
	env_change_timer += delta

	if env_change_timer > env_change_interval:
		current_environment_index += 1 if current_environment_index == 0 else -1
		ground.change_environment(game_environments[current_environment_index])
		background.change_environment(game_environments[current_environment_index])
		env_change_timer = 0

	total_distance_travelled += scroll_speed * delta
	distance_travelled_since_pattern_instance += scroll_speed * delta

	if distance_travelled_since_pattern_instance > 1024:
		var scene_instance = plains_entity_patterns[randi() % plains_entity_patterns.size()].instance()
		add_child(scene_instance)
		for child in scene_instance.get_children():
			child.position.x += total_distance_travelled + 1024
		distance_travelled_since_pattern_instance = 0
