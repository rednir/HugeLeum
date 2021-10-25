extends Control


var settings_scene = preload("res://UI/SettingsMenu.tscn")


func _ready():
	$Button.connect("pressed", self, "on_pressed")
	

func on_pressed():
	var instance = settings_scene.instance()
	add_child(instance)
