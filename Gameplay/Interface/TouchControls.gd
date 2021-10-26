extends Node2D


func _ready():
	$Movement/Left.connect("button_down", self, "on_left_down")
	$Movement/Left.connect("button_up", self, "on_left_up")
	$Movement/Right.connect("button_down", self, "on_right_down")
	$Movement/Right.connect("button_up", self, "on_right_up")
	$Jump.connect("button_down", self, "on_jump_down")
	$Jump.connect("button_up", self, "on_jump_up")


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
