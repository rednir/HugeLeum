extends StaticBody2D

const screen_width = 1024

const plains_texture = preload("res://Assets/plains-ground.png")
const desert_texture = preload("res://Assets/desert-ground.png")

onready var animation_player = $AnimationPlayer
onready var parallax_background = $ParallaxBackground
onready var main_sprite = $ParallaxBackground/ParallaxLayer/MainSprite
onready var other_sprite = $ParallaxBackground/ParallaxLayer/OtherSprite


func _ready():
	pass


func _process(delta):
	parallax_background.scroll_offset -= Vector2(400, 0) * delta


func _on_enviornment_change(env: int):
	other_sprite.texture = main_sprite.texture

	match env:
		GameEnvironment.PLAINS:
			main_sprite.texture = plains_texture

		GameEnvironment.DESERT:
			main_sprite.texture = desert_texture

	animation_player.play("switch")
