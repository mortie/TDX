extends CanvasLayer

@export var rounds: Node
@export var current_round: Node
@export var towers: Node
@export var guys: Node
@export var bullets: Node

@onready var status_label: Label = $StatusLabel
@onready var tower_dragger: Node3D = $"../TowerDragger"

const BOX_TOWER = preload("res://towers/BoxTower.tscn")

var round_nodes: Array[Node]
var next_round_index: int = 0

func _ready() -> void:
	round_nodes = rounds.get_children()
	$NextRoundBtn.connect("pressed", next_round)
	$SpawnBoxTower.connect("pressed", spawn_box_tower)

func next_round():
	if next_round_index >= len(round_nodes):
		return

	for guy in round_nodes[next_round_index].get_children():
		guy.reparent(current_round)
	next_round_index += 1
	status_label.text = "Round " + str(next_round_index)

func spawn_tower(res: PackedScene):
	var tower = res.instantiate()
	tower.guys = guys
	tower.bullets = bullets
	towers.add_child(tower)
	tower_dragger.pick_up(tower)

func spawn_box_tower():
	spawn_tower(BOX_TOWER)
