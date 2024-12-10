extends Node3D

@export var target: CollisionObject3D
@export var guys: Node
var target_loc: Vector3

var speed: float = 50
@onready var area = $Area3D
@onready var debug_line = $DebugLine
@onready var hit_sound: AudioStreamPlayer3D = $HitSound

var dying = false
var death_timer = 1

func _ready():
	target_loc = target.position

func find_next_target() -> bool:
	var nearest_guy: Node3D = null
	var nearest_sq_dist: float
	for guy in guys.get_children():
		if not is_instance_valid(guy):
			continue
		var sq_dist = (target_loc - guy.position).length_squared()
		if nearest_guy == null or sq_dist < nearest_sq_dist:
			nearest_guy = guy
			nearest_sq_dist = sq_dist

	if nearest_guy != null and nearest_sq_dist < 10 * 10:
		target = nearest_guy
		target_loc = target.position
		return true
	return false

func _physics_process(delta: float):
	if dying:
		death_timer -= delta
		if death_timer <= 0:
			queue_free()
		return

	if not is_instance_valid(target):
		if not find_next_target():
			queue_free()
			return

	debug_line.end = to_local(target.position)

	target_loc = target.position
	var step = to_local(target_loc).normalized() * speed * delta
	self.position += step

	if area.overlaps_body(target):
		self.visible = false
		target.emit_signal("damage")
		hit_sound.play()
		dying = true
