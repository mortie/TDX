extends Button

@export var scene: StringName

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	get_tree().change_scene_to_file(scene)
