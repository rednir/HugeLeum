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

const FIRST_PATTERN_OFFSET = 185

onready var canvas_layer = $CanvasLayer
onready var fade = $CanvasLayer/Fade/AnimationPlayer
onready var score_display = $CanvasLayer/ScoreDisplay
onready var heart_display = $CanvasLayer/HeartDisplay
onready var pause_button = $CanvasLayer/PauseButton

onready var camera = $Camera
onready var camera_animation_player = $Camera/AnimationPlayer
onready var ground = $Camera/Ground

onready var player = $Player
onready var background = $Background
onready var music_player = $MusicPlayer
onready var speed_up_audio = $SpeedUpAudio

export var hard_mode = false
export var powerup_appear_chance = 8
export var env_change_interval = 20
export var env_change_time_increment = 3
export var scroll_speed = 140
export var scroll_speed_change = 76
export var max_scroll_speed = 650
export var player_horizontal_movement_rate_increase = 1.07
export var pixels_per_metre = 300

var queue_free_on_death = false

var dead = false
var elapsed_time = 0
var total_distance_travelled = 0
var distance_travelled_since_pattern_instance = 0
var current_environment_index = 0
var entity_spawning_environment_index = 0
var env_change_timer = 0
var last_entity_pattern_index
var next_entity_pattern_index


func _ready():

	player.connect("death", self, "on_player_death")
	pause_button.connect("pressed", self, "on_pause_button_pressed")

	camera.set_scroll_speed(scroll_speed)

	randomize()

	last_entity_pattern_index = randi() % plains_entity_patterns.size()
	var starting_scene = plains_entity_patterns[last_entity_pattern_index].instance()
	for child in starting_scene.get_children():
		child.position.x += FIRST_PATTERN_OFFSET
	add_child(starting_scene)

	next_entity_pattern_index = randi() % plains_entity_patterns.size()
	while next_entity_pattern_index == last_entity_pattern_index:
		next_entity_pattern_index = randi() % plains_entity_patterns.size()
	last_entity_pattern_index = next_entity_pattern_index
	var next_scene = plains_entity_patterns[last_entity_pattern_index].instance()
	add_child(next_scene)
	for child in next_scene.get_children():
		child.position.x += 1024 + (FIRST_PATTERN_OFFSET / 2)
		if randi() % powerup_appear_chance == 1 and child.is_in_group("can_spawn_powerups"):
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
	if not elapsed_time < camera.initial_delay:
		total_distance_travelled += scroll_speed * delta
		distance_travelled_since_pattern_instance += scroll_speed * delta

	if distance_travelled_since_pattern_instance > 1024:
		var distance_till_env_change = scroll_speed * (env_change_interval - env_change_timer)

		# spawn entities for the next environment off screen if the env change is very close
		if distance_till_env_change < 1024 * 0.53:
			entity_spawning_environment_index += 1
			entity_spawning_environment_index %= GameEnvironment.list.size()

		var scene_instance
		match entity_spawning_environment_index:
			0:
				scene_instance = randomise_entity_pattern(plains_entity_patterns)
			1:
				scene_instance = randomise_entity_pattern(desert_entity_patterns)
			2:
				scene_instance = randomise_entity_pattern(ice_entity_patterns)
		add_child(scene_instance)

		for child in scene_instance.get_children():
			child.position.x += total_distance_travelled + 1024
			if randi() % powerup_appear_chance == 1 and child.is_in_group("can_spawn_powerups"):
				var powerup = powerups[randi() % powerups.size()].instance()

				# No point of spawning health pickups if max lives is 1.
				if player.max_lives == 1 and powerup.name == "HealthPickup":
					continue

				add_child(powerup)
				match child.name:
					"LargeSunflower":
						powerup.position = Vector2(child.position.x, child.position.y - 180)
					"Bee":
						powerup.position = Vector2(child.position.x, child.position.y - 120)
					"Spider":
						powerup.position = Vector2(child.position.x, child.position.y - 150)
					"Icicles1":
						powerup.position = Vector2(child.position.x, child.position.y - 150)
					"Snowman":
						powerup.position = Vector2(child.position.x, child.position.y - 200)
		distance_travelled_since_pattern_instance = 0

	heart_display.set_hearts(player.lives)
	score_display.score = int(round(total_distance_travelled / pixels_per_metre))

	if env_change_timer > env_change_interval:
		next_environment()


func randomise_entity_pattern(entity_patterns_list):
	next_entity_pattern_index = randi() % entity_patterns_list.size()
	# this pattern cannot be the same as last pattern
	while next_entity_pattern_index == last_entity_pattern_index:
		next_entity_pattern_index = randi() % entity_patterns_list.size()
	last_entity_pattern_index = next_entity_pattern_index
	var scene_instance = entity_patterns_list[last_entity_pattern_index].instance()
	return scene_instance


func next_environment():
	disable_active_hitboxes()

	current_environment_index += 1
	current_environment_index %= GameEnvironment.list.size()

	if current_environment_index != entity_spawning_environment_index:
		entity_spawning_environment_index = current_environment_index

	ground.change_environment(GameEnvironment.list[current_environment_index])
	background.change_environment(GameEnvironment.list[current_environment_index])

	camera_animation_player.play("speedup")
	speed_up_audio.play()

	scroll_speed += scroll_speed_change
	camera.set_scroll_speed(min(scroll_speed, max_scroll_speed))

	env_change_timer = 0
	env_change_interval += env_change_time_increment

	player.horizontal_move_speed *= player_horizontal_movement_rate_increase

	music_player.pitch_scale = min(music_player.pitch_scale + 0.04, 1.5)


func disable_active_hitboxes():
	for child in get_children():
		if "Pattern" in child.name:
			for entity in child.get_children():
				# only disappear if they were part of the this environment (not the next)
				if entity.is_in_group(env_index_to_env_name(current_environment_index)):
					if entity.get("disappear") == false:
						entity.disappear = true
					for great_grandchild in entity.get_children():
						if great_grandchild is CollisionShape2D:
							great_grandchild.set_deferred("disabled", true)
						else:
							for great_great_grandchild in great_grandchild.get_children():
								if great_great_grandchild is CollisionShape2D:
									great_great_grandchild.set_deferred("disabled", true)


func env_index_to_env_name(index):
	match index:
		0:
			return "plains"
		1:
			return "desert"
		2:
			return "ice"


func on_player_death():
	dead = true
	heart_display.set_hearts(0)

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

	if queue_free_on_death:
		fade.play("in")
		fade.connect("animation_finished", self, "on_queue_free_animation_finished", ["in"])
		return

	var results = results_scene.instance()
	results.connect("main_menu_pressed", self, "on_main_menu_button_pressed")
	results.connect("play_again_pressed", self, "on_play_again_button_pressed")
	results.set_display_stats(
		total_distance_travelled / pixels_per_metre,
		player.total_times_jumped,
		player.num_of_powerups_collected
	)
	canvas_layer.add_child(results)


func on_pause_button_pressed():
	if dead == false:
		get_tree().paused = true
		var pause_menu = pause_menu_scene.instance()
		pause_menu.connect("main_menu_pressed", self, "on_main_menu_button_pressed")
		pause_menu.connect("resume_pressed", self, "on_resume_button_pressed")
		canvas_layer.add_child(pause_menu)


func on_resume_button_pressed():
	get_tree().paused = false


func on_main_menu_button_pressed():
	get_tree().paused = false
	music_player.stop()
	fade.play("in")
	fade.connect("animation_finished", self, "on_main_menu_animation_finished", ["in"])


func on_play_again_button_pressed():
	dead = false
	fade.play("in")
	fade.connect("animation_finished", self, "on_play_again_animation_finished", ["in"])


func on_main_menu_animation_finished(_a, _b):
	get_tree().change_scene("res://UI/MainMenu.tscn")


func on_play_again_animation_finished(_a, _b):
	get_tree().change_scene(
		"res://Gameplay/HardMode.tscn" if hard_mode else "res://Gameplay/Game.tscn"
	)


func on_queue_free_animation_finished(_a, _b):
	queue_free()
