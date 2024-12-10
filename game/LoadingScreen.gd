extends Node3D

# Yes this might seem useless, but it's not:
# by just having a scene which contains anything we might see,
# we avoid stuttering as new things show up for the first time.

var timer: float = 1

func _process(delta: float):
	timer -= delta
	if timer <= 0:
		get_tree().change_scene_to_file("res://game/MainMenu.tscn")
