extends Node

@export var money: int
@export var health: int
@export var rounds: Node
@export var death_area: CollisionObject3D
@export var camera: Camera3D:
	set(c): $TowerDragger.camera = c

@onready var towers: Node = $Towers
@onready var guys: Node = $Guys
@onready var bullets: Node = $Bullets

@onready var status_label: Label = $StatusLabel
@onready var tower_dragger: Node3D = $TowerDragger
@onready var money_count_label: Label = $MoneyCountLabel
@onready var health_count_label: Label = $HealthCountLabel
@onready var next_round_btn: Button = $NextRoundBtn

@onready var buy_tower_btns = [
	[$BuyBoxTower, preload("res://towers/BoxTower.tscn"), 5],
]

var round_nodes: Array[Node]
var next_round_index: int = 0
var round_prize: int = 0

func _ready():
	round_nodes = rounds.get_children()
	update_money(money)
	update_health(health)
	next_round_btn.connect("pressed", next_round)

	for btn in buy_tower_btns:
		btn[0].connect("pressed", func buy():
			spawn_tower(btn[1], btn[2]))
	
	death_area.connect("body_entered", on_body_entered_death_area)

func _process(_delta: float):
	if next_round_btn.disabled and guys.get_child_count() == 0:
		next_round_btn.disabled = false
		update_money(money + round_prize)

func next_round():
	if next_round_index >= len(round_nodes):
		return

	var round = round_nodes[next_round_index]
	for guy in round.get_children():
		guy.reparent(guys)
	if round.has_meta("prize"):
		round_prize = round.get_meta("prize")
	else:
		round_prize = 0
	next_round_index += 1
	status_label.text = "Round " + str(next_round_index)
	next_round_btn.disabled = true

func update_money(new_money: int):
	money = new_money
	money_count_label.text = str(money) + "¢"
	for btn in buy_tower_btns:
		btn[0].disabled = btn[2] > money

func update_health(new_health: int):
	health = new_health
	health_count_label.text = str(health)

func spawn_tower(res: PackedScene, price: int):
	if price > money:
		return

	money -= price
	money_count_label.text = str(money) + "¢"

	var tower = res.instantiate()
	tower.guys = guys
	tower.bullets = bullets
	towers.add_child(tower)
	tower_dragger.pick_up(tower)

func on_body_entered_death_area(body: Node3D):
	if not body.get_meta("is_guy", false):
		return
	update_health(health - 1)
	body.queue_free()
