extends CenterContainer


signal main_menu_pressed
signal play_again_pressed

var nullll = false


func _ready():
	$Panel/MainMenuButton.connect("pressed", self, "on_main_menu_button_pressed")
	$Panel/PlayAgainButton.connect("pressed", self, "on_play_again_button_pressed")


func set_display_stats(score=0, jump_count=0, powerup_count=0):
	var score_label = $Panel/Score
	var info_label = $Panel/InfoLabel

	if score_label == null:
		nullll = true
		
	var score_label_text = str(int(round(score))) + "m"
	print(score_label_text)
	score_label.text = score_label_text
	var info_label_text = "Total jumps: " + str(jump_count) + "\nPowerups collected: " + str(powerup_count)
	print(info_label_text)
	info_label.text = info_label_text


func on_main_menu_button_pressed():
	emit_signal("main_menu_pressed")


func on_play_again_button_pressed():
	emit_signal("play_again_pressed")
