extends RigidBody2D


onready var animation_player = $AnimationPlayer


func _ready():
	pass


func _process(_delta):
	pass


func on_pickup():
	get_child(0).set_deferred("disabled", true)
	animation_player.play("pickup")
	animation_player.connect("animation_finished", self, "on_animation_finished", ["pickup"])


func on_animation_finished(_a, _b):
	queue_free()