extends Node3D

@export var target: CollisionObject3D

var speed: float = 50
@onready var area = $Area3D
@onready var debug_line = $DebugLine
@onready var hit_sound: AudioStreamPlayer3D = $HitSound

var dying = false
var death_timer = 1

func _physics_process(delta: float) -> void:
	if dying:
		death_timer -= delta
		if death_timer <= 0:
			queue_free()
		return

	if not is_instance_valid(target):
		queue_free()
		return

	debug_line.end = to_local(target.position)

	var step = to_local(target.position).normalized() * speed * delta
	self.position += step

	if area.overlaps_body(target):
		self.visible = false
		target.emit_signal("damage")
		hit_sound.play()
		dying = true
