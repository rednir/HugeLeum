extends Control

const heart_full_texture = preload("res://Assets/heart-disp-full.png")
const heart_empty_texture = preload("res://Assets/heart-disp-empty.png")

onready var container = $HBoxContainer

export var max_hearts = 3
export var heart_count = 2


func _ready():
	for _i in range(heart_count):
		var heart = TextureRect.new()
		heart.texture = heart_full_texture
		container.add_child(heart)

	for _i in range(max_hearts - heart_count):
		var heart = TextureRect.new()
		heart.texture = heart_empty_texture
		container.add_child(heart)


func set_hearts(num: int):
	num = max_hearts if num > max_hearts else num

	if num > heart_count:
		add_hearts(num)
	elif num < heart_count:
		remove_hearts(num)

	heart_count = num


func add_hearts(num: int):
	var children = container.get_children()
	if children.size() > 0:
		for _i in range(num - heart_count):
			children[children.size() - 1].queue_free()

	for _i in range(num - heart_count):
		var heart = TextureRect.new()
		heart.texture = heart_full_texture
		container.add_child(heart)


func remove_hearts(num: int):
	var children = container.get_children()
	if children.size() > 0:
		for i in range(heart_count - num):
			children[heart_count - 1 - i].texture = heart_empty_texture
