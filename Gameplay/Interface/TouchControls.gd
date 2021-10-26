extends Node2D

onready var left_side = $LeftSide
onready var right_side = $RightSide


func _ready():
	$LeftSide/Left.connect("pressed", self, "on_left_down")
	$LeftSide/Left.connect("released", self, "on_left_up")
	$LeftSide/Right.connect("pressed", self, "on_right_down")
	$LeftSide/Right.connect("released", self, "on_right_up")
	$RightSide/Jump.connect("pressed", self, "on_jump_down")
	$RightSide/Jump.connect("released", self, "on_jump_up")


func _process(_delta):
	visible = Settings.show_touch_controls
	left_side.rect_scale = Vector2(Settings.touch_controls_scale, Settings.touch_controls_scale)
	right_side.rect_scale = Vector2(Settings.touch_controls_scale, Settings.touch_controls_scale)


func on_left_down():
	Input.action_press("move_left")


func on_right_down():
	Input.action_press("move_right")


func on_jump_down():
	Input.action_press("jump")


func on_left_up():
	Input.action_release("move_left")


func on_right_up():
	Input.action_release("move_right")


func on_jump_up():
	Input.action_release("jump")
