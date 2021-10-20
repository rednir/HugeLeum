extends StaticBody2D

const plains_texture = preload("res://Assets/plains-ground.png")
const desert_texture = preload("res://Assets/desert-ground.png")

onready var animation_player = $AnimationPlayer
onready var main_sprite = $MainSprite
onready var other_sprite = $OtherSprite


func _ready():
	pass


func _on_enviornment_change(env: int):
	other_sprite.texture = main_sprite.texture

	match env:
		GameEnvironment.PLAINS:
			main_sprite.texture = plains_texture

		GameEnvironment.DESERT:
			main_sprite.texture = desert_texture

	animation_player.play("switch")
