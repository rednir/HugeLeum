extends Node2D

const plains_texture = preload("res://Assets/plains-bg.png")
const desert_texture = preload("res://Assets/desert-bg.png")

export var speed = 20

onready var main_sprite = $ParallaxBackground/ParallaxLayer/MainSprite
onready var other_sprite = $ParallaxBackground/ParallaxLayer/OtherSprite
onready var animation_player = $AnimationPlayer


func change_environment(env: int):
	other_sprite.texture = main_sprite.texture
	
	match env:
		GameEnvironment.PLAINS:
			main_sprite.texture = plains_texture

		GameEnvironment.DESERT:
			main_sprite.texture = desert_texture

	animation_player.play("switch")
