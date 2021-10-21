extends RigidBody2D


func _ready():
	pass


func _process(delta):
	pass


func on_pickup():
	get_child(0).set_disabled(true)

