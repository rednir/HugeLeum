extends Node2D

const plainsbg_texture = preload("res://Assets/plains-bg.png")
const plainsbg2_texture = preload("res://Assets/plains-bg2.png")
const desertbg_texture = preload("res://Assets/desert-bg.png")
const desertbg2_texture = preload("res://Assets/desert-bg2.png")
const icebg_texture = preload("res://Assets/ice-bg.png")
const icebg2_texture = preload("res://Assets/ice-bg2.png")

export var speed = 20

onready var bg_main_sprite = $ParallaxBackground/BgLayer/MainSprite
onready var bg_other_sprite = $ParallaxBackground/BgLayer/OtherSprite
onready var bg2_main_sprite = $ParallaxBackground/Bg2Layer/MainSprite2
onready var bg2_other_sprite = $ParallaxBackground/Bg2Layer/OtherSprite2

onready var snow = $CanvasLayer/Snow
onready var sand = $CanvasLayer/Sand

onready var animation_player = $AnimationPlayer


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

		GameEnvironment.ICE:
			bg_main_sprite.texture = icebg_texture
			bg2_main_sprite.texture = icebg2_texture
			
	snow.emitting = env == GameEnvironment.ICE
	sand.emitting = env == GameEnvironment.DESERT

	animation_player.play("switch")
