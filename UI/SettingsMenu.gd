extends CenterContainer


onready var animation_player = $AnimationPlayer
onready var done_button = $Panel/DoneButton
onready var master_volume_slider = $Panel/MasterVolume/Slider


func _ready():
	done_button.connect("pressed", self, "on_done_button_pressed")
	master_volume_slider.connect("value_changed", self, "on_master_volume_changed")


func on_done_button_pressed():
	animation_player.play("out")
	animation_player.connect("animation_finished", self, "on_animation_finished")


func on_animation_finished(_a):
	queue_free()


func on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value <= master_volume_slider.min_value)