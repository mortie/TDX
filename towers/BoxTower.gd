extends Node3D

@export var guys: Node
@export var bullets: Node

var fire_range: float = 40
var fire_timeout: float = 1
var timer: float = 0
var bullet_scene = preload("res://misc/Bullet.tscn")
@onready var muzzle: Node3D = $Muzzle
@onready var shoot_sound: AudioStreamPlayer3D = $ShootSound

func _physics_process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		return

	var closest_guy: Node = null
	var closest_sq_dist: float = 0
	for guy in guys.get_children():
		var sq_dist = (self.global_position - guy.global_position).length_squared()
		if closest_guy == null or sq_dist < closest_sq_dist:
			closest_guy = guy
			closest_sq_dist = sq_dist

	if closest_guy == null or closest_sq_dist > fire_range * fire_range:
		return

	var bullet = bullet_scene.instantiate()
	bullet.target = closest_guy
	bullet.position = muzzle.global_position
	bullets.add_child(bullet)
	timer += fire_timeout
	shoot_sound.play()
