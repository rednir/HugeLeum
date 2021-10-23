extends CenterContainer


onready var animation_player = $AnimationPlayer


signal main_menu_pressed
signal resume_pressed


func _ready():
	$Panel/MainMenuButton.connect("pressed", self, "on_main_menu_button_pressed")
	$Panel/ResumeButton.connect("pressed", self, "on_resume_button_pressed")


func on_main_menu_button_pressed():
	emit_signal("main_menu_pressed")

func on_resume_button_pressed():
	animation_player.play("out")
	animation_player.connect("animation_finished", self, "on_out_anim_finished", ["out"])


func on_out_anim_finished(_a, _b):
	emit_signal("resume_pressed")
	queue_free()
