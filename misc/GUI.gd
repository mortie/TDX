extends Node3D

@export var camera: Camera3D

var held_node: Node3D
var held_node_rid: RID
var hovered_node: Node3D
var hovered_node_rid: RID

func intersect_mouse_world_pos() -> Dictionary:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 600
	var params = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	if held_node:
		params.exclude = [held_node_rid]
	return get_world_3d().direct_space_state.intersect_ray(params)

func _input(evt: InputEvent):
	if evt is InputEventMouseButton and evt.pressed and evt.button_index == MOUSE_BUTTON_LEFT:
		if held_node:
			held_node = null
		elif hovered_node:
			held_node = hovered_node
			held_node_rid = hovered_node_rid
			hovered_node = null

func _physics_process(_delta: float):
	var intersection = intersect_mouse_world_pos()
	if intersection.is_empty():
		hovered_node = null
		return

	if held_node:
		held_node.position = intersection["position"]
	else:
		var node = intersection["collider"] as Node3D
		if node.has_meta("is_tower"):
			hovered_node = intersection["collider"]
			hovered_node_rid = intersection["rid"]
		else:
			hovered_node = null
