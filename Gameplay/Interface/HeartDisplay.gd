extends Control

const heart_full_texture = preload("res://Assets/heart-disp-full.png")
const heart_empty_texture = preload("res://Assets/heart-disp-empty.png")

onready var container = $HBoxContainer
onready var animation_player = $AnimationPlayer

export var max_hearts = 2
export var heart_count = 2


func initialize():
	for _i in range(heart_count):
		var heart = TextureRect.new()
		heart.texture = heart_full_texture
		container.add_child(heart)

	for _i in range(max_hearts - heart_count):
		var heart = TextureRect.new()
		heart.texture = heart_empty_texture
		container.add_child(heart)


func set_hearts(new_heart_count: int):
	var children = container.get_children()
	if children.size() == 0:
		initialize()

	new_heart_count = max_hearts if new_heart_count > max_hearts else new_heart_count

	if new_heart_count > heart_count:
		for _i in range(new_heart_count - heart_count):
			children[children.size() - 1].queue_free()
	
		for _i in range(new_heart_count - heart_count):
			var heart = TextureRect.new()
			heart.texture = heart_full_texture
			container.add_child(heart)
	elif new_heart_count < heart_count:
		for i in range(heart_count - new_heart_count):
			children[heart_count - 1 - i].texture = heart_empty_texture
		animation_player.play("loss")

	heart_count = new_heart_count

