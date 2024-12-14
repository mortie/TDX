extends AudioStreamPlayer

# This is necessary because setting looping to true doesn't work with web exports :(

func _ready():
	self.finished.connect(play)
