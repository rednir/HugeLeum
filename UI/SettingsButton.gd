extends Control


var settings_scene = preload("res://UI/SettingsMenu.tscn")
var instance = null


func _ready():
	$Button.connect("pressed", self, "on_pressed")
	

func on_pressed():
	if not is_instance_valid(instance):
		instance = settings_scene.instance()
		add_child(instance)
