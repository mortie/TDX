class_name DebugLine
extends MeshInstance3D

@export var color: Color = Color.GREEN

var start: Vector3
var end: Vector3
var material: ORMMaterial3D = ORMMaterial3D.new()

func _ready():
	mesh = ImmediateMesh.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
func _process(_delta):
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	mesh.surface_add_vertex(start)
	mesh.surface_add_vertex(end)
	mesh.surface_end()
