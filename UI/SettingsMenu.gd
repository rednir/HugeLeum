extends CanvasLayer


onready var animation_player = $CenterContainer/AnimationPlayer
onready var done_button = $CenterContainer/Panel/DoneButton
onready var master_volume_slider = $CenterContainer/Panel/MasterVolume/Slider


func _ready():
	done_button.connect("pressed", self, "on_done_button_pressed")

	master_volume_slider.connect("value_changed", self, "on_master_volume_changed")
	master_volume_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))


func on_done_button_pressed():
	animation_player.play("out")
	animation_player.connect("animation_finished", self, "on_animation_finished")


func on_animation_finished(_a):
	queue_free()


func on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value <= master_volume_slider.min_value)
