extends Button

onready var audio_stream_player = $AudioStreamPlayer
onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_on_pressed")
	self.connect("button_down", self, "_on_down")
	self.connect("button_up", self, "_on_up")
	
	rect_pivot_offset = rect_size / 2


func _on_pressed():
	audio_stream_player.play()


func _on_down():
	animation_player.play("down")


func _on_up():
	animation_player.play("up")
