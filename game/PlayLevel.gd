extends Button

@export var scene: Resource

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	get_tree().change_scene_to_packed(scene)
