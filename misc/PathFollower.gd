extends Node

@export var speed: float = 50
@export var path: Node
@export var body: CharacterBody3D

@export var debug_line: DebugLine

var path_nodes: Array[Marker3D]
var target_index: int = -1
var target_node: Marker3D
var target_pos: Vector2
var target_radius_sq: float
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng = RandomNumberGenerator.new()

func random_pos_in_node(node: Marker3D) -> Vector2:
	var radius = node.gizmo_extents
	while true:
		var pos = Vector2(
			rng.randf_range(-radius, radius),
			rng.randf_range(-radius, radius))
		if pos.length_squared() <= radius * radius:
			return Vector2(node.position.x, node.position.z) + pos
	return Vector2.ZERO

func set_target_index(index):
	if index < 0 or index >= len(path_nodes):
		target_index = -1
		target_node = null
		return

	target_index = index
	target_node = path_nodes[index]
	target_pos = random_pos_in_node(target_node)
	target_radius_sq = target_node.gizmo_extents * target_node.gizmo_extents

func _ready():
	for child in path.get_children():
		if is_instance_of(child, Marker3D):
			path_nodes.push_back(child)

	set_target_index(0)

func _physics_process(delta: float):
	if target_node == null:
		return

	var current_pos = Vector2(body.position.x, body.position.z)
	var diff = target_pos - current_pos
	if diff.length_squared() < target_radius_sq:
		set_target_index(target_index + 1)
		return

	var step = diff.normalized() * speed * delta
	body.velocity.x += step.x
	body.velocity.z += step.y
	body.velocity.y -= gravity * delta
	body.velocity *= 0.95
	body.move_and_slide()
	
	if debug_line != null:
		var target_vec = Vector3(target_pos.x, body.position.y, target_pos.y)
		debug_line.end = target_vec - body.position
