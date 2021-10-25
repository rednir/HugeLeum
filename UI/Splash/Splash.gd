extends Control


onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.connect("animation_finished", self, "_on_animation_finished", ["show"])


func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		_on_animation_finished(null, null)

	
func _on_animation_finished(_a, _b):
	get_tree().change_scene("UI/MainMenu.tscn")
