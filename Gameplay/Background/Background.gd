extends Node2D

const plainsbg_texture = preload("res://Assets/plains-bg.png")
const desertbg_texture = preload("res://Assets/desert-bg.png")
const plainsbg2_texture = preload("res://Assets/plains-bg2.png")
const desertbg2_texture = preload("res://Assets/desert-bg2.png")

export var speed = 20

onready var bg_main_sprite = $ParallaxBackground/BgLayer/MainSprite
onready var bg_other_sprite = $ParallaxBackground/BgLayer/OtherSprite
onready var bg2_main_sprite = $ParallaxBackground/Bg2Layer/MainSprite2
onready var bg2_other_sprite = $ParallaxBackground/Bg2Layer/OtherSprite2

onready var animation_player = $AnimationPlayer


func _process(delta):
	return
	if (Input.is_action_just_pressed("jump")):
		change_environment(GameEnvironment.DESERT)
	if (Input.is_action_just_pressed("move_left")):
		change_environment(GameEnvironment.PLAINS)


func change_environment(env: int):
	bg_other_sprite.texture = bg_main_sprite.texture
	bg2_other_sprite.texture = bg2_main_sprite.texture
	
	match env:
		GameEnvironment.PLAINS:
			bg_main_sprite.texture = plainsbg_texture
			bg2_main_sprite.texture = plainsbg2_texture

		GameEnvironment.DESERT:
			bg_main_sprite.texture = desertbg_texture
			bg2_main_sprite.texture = desertbg2_texture

	animation_player.play("switch")
