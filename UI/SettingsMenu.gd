extends CanvasLayer


onready var animation_player = $CenterContainer/AnimationPlayer
onready var done_button = $CenterContainer/Panel/DoneButton

onready var master_volume_slider = $CenterContainer/Panel/VBoxContainer/MasterVolume/Slider
onready var touch_controls_button = $CenterContainer/Panel/VBoxContainer/TouchControls/CheckButton
onready var touch_controls_scale_slider = $CenterContainer/Panel/VBoxContainer/TouchControlsScale/Slider


func _ready():
	done_button.connect("pressed", self, "on_done_button_pressed")

	master_volume_slider.connect("value_changed", self, "on_master_volume_changed")
	master_volume_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

	touch_controls_button.connect("toggled", self, "on_touch_controls_toggled")
	touch_controls_button.pressed = Settings.show_touch_controls
	touch_controls_button.disabled = Settings.FORCE_TOUCH_CONTROLS

	touch_controls_scale_slider.connect("value_changed", self, "on_touch_controls_scale_value_changed")
	touch_controls_scale_slider.value = Settings.touch_controls_scale
	touch_controls_scale_slider.editable = Settings.show_touch_controls


func on_done_button_pressed():
	animation_player.play("out")
	animation_player.connect("animation_finished", self, "on_animation_finished")


func on_animation_finished(_a):
	queue_free()


func on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value <= master_volume_slider.min_value)


func on_touch_controls_toggled(value):
	Settings.show_touch_controls = value
	touch_controls_scale_slider.editable = value


func on_touch_controls_scale_value_changed(value):
	Settings.touch_controls_scale = value
