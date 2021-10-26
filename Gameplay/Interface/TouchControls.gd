extends Node2D

onready var movement_container = $Movement
onready var jump_button = $Jump


func _ready():
	$Movement/Left.connect("button_down", self, "on_left_down")
	$Movement/Left.connect("button_up", self, "on_left_up")
	$Movement/Right.connect("button_down", self, "on_right_down")
	$Movement/Right.connect("button_up", self, "on_right_up")
	$Jump.connect("button_down", self, "on_jump_down")
	$Jump.connect("button_up", self, "on_jump_up")


func _process(_delta):
	visible = Settings.show_touch_controls
	movement_container.rect_scale = Vector2(Settings.touch_controls_scale, Settings.touch_controls_scale)
	jump_button.rect_scale = Vector2(Settings.touch_controls_scale, Settings.touch_controls_scale)


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
