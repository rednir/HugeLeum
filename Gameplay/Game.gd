extends Node2D

const plains_entity_patterns = [
	preload("res://Gameplay/EntityPatterns/Pattern1.tscn"),
	preload("res://Gameplay/EntityPatterns/Pattern2.tscn"),
	preload("res://Gameplay/EntityPatterns/Pattern3.tscn"),
	preload("res://Gameplay/EntityPatterns/Pattern4.tscn")
]

const powerups = [
	preload("res://Gameplay/Powerups/HealthPickup.tscn"),
	preload("res://Gameplay/Powerups/ShieldPowerup.tscn")
]


onready var camera = $Camera
onready var ground = $Camera/Ground
onready var score_display = $Camera/ScoreDisplay
onready var background = $Background
onready var music_player = $MusicPlayer

export var env_change_interval = 20
export var env_change_time_increment = 3
export var scroll_speed = 120
export var scroll_speed_change = 75
export var max_scroll_speed = 500

var elapsed_time = 0
var total_distance_travelled = 0
var distance_travelled_since_pattern_instance = 0
var current_environment_index = 0
var env_change_timer = 0


func _ready():
	camera.set_scroll_speed(scroll_speed)

	var starting_scene = plains_entity_patterns[randi() % plains_entity_patterns.size()].instance()
	add_child(starting_scene)

	var next_scene = plains_entity_patterns[randi() % plains_entity_patterns.size()].instance()
	add_child(next_scene)
	for child in next_scene.get_children():
		child.position.x += 1024
		if randi() % 10 == 1 and child.is_in_group("can_spawn_powerups"):
			var powerup = powerups[randi() % powerups.size()].instance()
			add_child(powerup)
			match child.name:
				"LargeSunflower":
					powerup.position = Vector2(child.position.x, child.position.y - 180)
				"Bee":
					powerup.position = Vector2(child.position.x, child.position.y - 120)

	music_player.playing = true


func _process(delta):
	env_change_timer += delta

	elapsed_time += delta
	if not elapsed_time < 3:
		total_distance_travelled += scroll_speed * delta
		distance_travelled_since_pattern_instance += scroll_speed * delta

	if distance_travelled_since_pattern_instance > 1024:
		var scene_instance = plains_entity_patterns[randi() % plains_entity_patterns.size()].instance()
		add_child(scene_instance)
		for child in scene_instance.get_children():
			child.position.x += total_distance_travelled + 1024
			if randi() % 10 == 1 and child.is_in_group("can_spawn_powerups"):
				var powerup = powerups[randi() % powerups.size()].instance()
				add_child(powerup)
				match child.name:
					"LargeSunflower":
						powerup.position = Vector2(child.position.x, child.position.y - 180)
					"Bee":
						powerup.position = Vector2(child.position.x, child.position.y - 120)
		distance_travelled_since_pattern_instance = 0

	score_display.score = int(round(total_distance_travelled / 300)) 

	if env_change_timer > env_change_interval:
		next_environment()


func next_environment():
	current_environment_index += 1
	current_environment_index %= GameEnvironment.list.size()
	ground.change_environment(GameEnvironment.list[current_environment_index])
	background.change_environment(GameEnvironment.list[current_environment_index])

	scroll_speed += scroll_speed_change
	camera.set_scroll_speed(min(scroll_speed, max_scroll_speed))

	env_change_timer = 0
	env_change_interval += env_change_time_increment
