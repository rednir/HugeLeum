extends CenterContainer


signal main_menu_pressed
signal play_again_pressed


func _ready():
	$Panel/MainMenuButton.connect("pressed", self, "on_main_menu_button_pressed")
	$Panel/PlayAgainButton.connect("pressed", self, "on_play_again_button_pressed")


func on_main_menu_button_pressed():
	emit_signal("main_menu_pressed")


func on_play_again_button_pressed():
	emit_signal("play_again_pressed")
