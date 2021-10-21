extends StaticBody2D


const screen_width = 1024

const plains_texture = preload("res://Assets/plains-ground.png")
const desert_texture = preload("res://Assets/desert-ground.png")

onready var animation_player = $AnimationPlayer
onready var main_sprite = $MainSprite
onready var other_sprite = $OtherSprite
onready var camera = $Camera

var camera_starting_pos_x
var camera_distance_travelled_x = 0
var camera_last_pos_x


func _ready():
	pass


func _process(_delta):
	if camera_starting_pos_x == null:
		camera_starting_pos_x = camera.position.x

	camera_distance_travelled_x += camera.get_camera_position().x - camera_last_pos_x
	print(camera_distance_travelled_x)

	if camera_distance_travelled_x > screen_width * 2:
		translate(Vector2(screen_width * 2, 0))
		print("translated")


func _on_enviornment_change(env: int):
	other_sprite.texture = main_sprite.texture

	match env:
		GameEnvironment.PLAINS:
			main_sprite.texture = plains_texture

		GameEnvironment.DESERT:
			main_sprite.texture = desert_texture

	animation_player.play("switch")
