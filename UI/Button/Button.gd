extends Button


onready var audio_stream_player = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_on_pressed")


func _on_pressed():
	audio_stream_player.play()
	
