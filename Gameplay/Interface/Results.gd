extends CenterContainer


signal main_menu_pressed
signal play_again_pressed


func _ready():
	$Panel/MainMenuButton.connect("pressed", self, "on_main_menu_button_pressed")
	$Panel/PlayAgainButton.connect("pressed", self, "on_play_again_button_pressed")


func set_display_stats(score=0, jump_count=0, powerup_count=0):
	var score_label = $Panel/Score
	var info_label = $Panel/InfoLabel
	score_label.text = str(int(round(score))) + "m"
	info_label.text = "Total jumps: " + str(jump_count) + "\nPowerups collected: " + str(powerup_count)


func on_main_menu_button_pressed():
	emit_signal("main_menu_pressed")


func on_play_again_button_pressed():
	emit_signal("play_again_pressed")
