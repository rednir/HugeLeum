extends RigidBody2D


func _ready():
	pass


func _process(_delta):
	pass


func on_pickup():
	get_child(0).set_deferred("disabled", true)
	print(get_child(0).name)
	print("disabled")

	
func reset_hitbox():
	get_child(0).set_deferred("disabled", false)
	print(get_child(0).name)
	print("enabled")
	