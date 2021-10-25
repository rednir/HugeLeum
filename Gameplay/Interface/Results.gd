extends CenterContainer


signal main_menu_pressed
signal play_again_pressed


func _ready():
	$Panel/MainMenuButton.connect("pressed", self, "on_main_menu_button_pressed")
	$Panel/PlayAgainButton.connect("pressed", self, "on_play_again_button_pressed")


func set_display_stats(score, jump_count, powerup_count):
	var remark
	if score > 210:
		remark = "It's too good to be true...?"
	elif score > 160:
		remark = "YUou may be small but the giants fear you."
	elif score > 110:
		remark = "Incredible! Don't judge a worm by its size!"
	elif score > 70:
		remark = "Not bad... but you can do better."
	elif score > 40:
		remark = "A mediocre performance, even for a worm's standards."
	else:
		remark = "It seems you were no match against the giants..."

	# luca what is the point of this ˅˅
	$Panel/Score.text = str(int(round(score))) + "m"
	$Panel/InfoLabel.text = remark + "\n\n • Total jumps: " + str(jump_count) + "\n • Powerups collected: " + str(powerup_count)


func on_main_menu_button_pressed():
	emit_signal("main_menu_pressed")


func on_play_again_button_pressed():
	emit_signal("play_again_pressed")
