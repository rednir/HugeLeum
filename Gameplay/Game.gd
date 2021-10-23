extends Node2D

const plains_entity_patterns = [
	preload("res://Gameplay/EntityPatterns/Plains/Pattern1.tscn"),
	preload("res://Gameplay/EntityPatterns/Plains/Pattern2.tscn"),
	preload("res://Gameplay/EntityPatterns/Plains/Pattern3.tscn"),
	preload("res://Gameplay/EntityPatterns/Plains/Pattern4.tscn")
]

const desert_entity_patterns = [
	preload("res://Gameplay/EntityPatterns/Desert/Pattern1.tscn"),
	preload("res://Gameplay/EntityPatterns/Desert/Pattern2.tscn"),
	preload("res://Gameplay/EntityPatterns/Desert/Pattern3.tscn")
]

const ice_entity_patterns = [
	preload("res://Gameplay/EntityPatterns/Ice/Pattern1.tscn"),
	preload("res://Gameplay/EntityPatterns/Ice/Pattern2.tscn"),
	preload("res://Gameplay/EntityPatterns/Ice/Pattern3.tscn"),
	preload("res://Gameplay/EntityPatterns/Ice/Pattern4.tscn")
]

const powerups = [
	preload("res://Gameplay/Powerups/HealthPickup.tscn"),
	preload("res://Gameplay/Powerups/ShieldPowerup.tscn")
]

const results_scene = preload("res://Gameplay/Interface/Results.tscn")
const pause_menu_scene = preload("res://Gameplay/Interface/PauseMenu.tscn")

onready var canvas_layer = $CanvasLayer
onready var fade = $CanvasLayer/Fade/AnimationPlayer
onready var score_display = $CanvasLayer/ScoreDisplay
onready var pause_button = $CanvasLayer/PauseButton

onready var camera = $Camera
onready var camera_animation_player = $Camera/AnimationPlayer
onready var ground = $Camera/Ground

onready var player = $Player
onready var background = $Background
onready var music_player = $MusicPlayer

export var env_change_interval = 20
export var env_change_time_increment = 3
export var scroll_speed = 120
export var scroll_speed_change = 75
export var max_scroll_speed = 500

export var pixels_per_metre = 300

var elapsed_time = 0
var total_distance_travelled = 0
var distance_travelled_since_pattern_instance = 0
var current_environment_index = 0
var env_change_timer = 0


func _ready():
	player.connect("death", self, "on_player_death")
	pause_button.connect("pressed", self, "on_pause_button_pressed")

	camera.set_scroll_speed(scroll_speed)

	randomize()

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
		var scene_instance
		match current_environment_index:
			0:
				scene_instance = plains_entity_patterns[randi() % plains_entity_patterns.size()].instance()
			1:
				scene_instance = desert_entity_patterns[randi() % desert_entity_patterns.size()].instance()
			2:
				scene_instance = ice_entity_patterns[randi() % ice_entity_patterns.size()].instance()
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

	score_display.score = int(round(total_distance_travelled / pixels_per_metre))

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


func on_player_death():
	music_player.stop()
	camera_animation_player.play("death")
	camera.set_scroll_speed(0)
	set_process(false)

	# Wait a bit before showing results screen.
	var timer = Timer.new()
	timer.set_wait_time(1)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()

	var results = results_scene.instance()
	results.connect("main_menu_pressed", self, "on_main_menu_button_pressed")
	results.connect("play_again_pressed", self, "on_play_again_button_pressed")
	results.set_display_stats(total_distance_travelled / pixels_per_metre, player.total_times_jumped, player.num_of_powerups_collected)
	canvas_layer.add_child(results)


func on_pause_button_pressed():
	get_tree().paused = true
	var pause_menu = pause_menu_scene.instance()
	pause_menu.connect("main_menu_pressed", self, "on_main_menu_button_pressed")
	pause_menu.connect("resume_pressed", self, "on_resume_button_pressed")
	canvas_layer.add_child(pause_menu)


func on_resume_button_pressed():
	get_tree().paused = false


func on_main_menu_button_pressed():
	get_tree().paused = false
	fade.play("in")
	fade.connect("animation_finished", self, "on_main_menu_animation_finished", ["in"])


func on_play_again_button_pressed():
	fade.play("in")
	fade.connect("animation_finished", self, "on_play_again_animation_finished", ["in"])


func on_main_menu_animation_finished(_a, _b):
	get_tree().change_scene("res://UI/MainMenu.tscn")


func on_play_again_animation_finished(_a, _b):
	get_tree().change_scene("res://Gameplay/Game.tscn")
