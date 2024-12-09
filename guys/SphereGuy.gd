extends CharacterBody3D

signal damage

@onready var sphere = $CSGSphere3D
var hitpoints = 2

@export var path: Node:
	set(value): $PathFollower.path = value
	
func _ready():
	damage.connect(_on_damage)
	
func _on_damage():
	hitpoints -= 1
	if hitpoints == 1:
		sphere.material = ORMMaterial3D.new()
		sphere.material.albedo_color = Color(0.5, 0.2, 0.1)
	elif hitpoints <= 0:
		queue_free()
