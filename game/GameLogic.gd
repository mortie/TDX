extends Node

@export var money: int
@export var health: int
@export var rounds: Node
@export var death_area: CollisionObject3D
@export var camera: Camera3D:
	set(c): $TowerDragger.camera = c
@export var game_over_scene: Resource

@onready var towers: Node = $Towers
@onready var guys: Node = $Guys
@onready var bullets: Node = $Bullets

@onready var status_label: Label = $StatusLabel
@onready var tower_dragger: Node3D = $TowerDragger
@onready var money_count_label: Label = $MoneyCountLabel
@onready var health_count_label: Label = $HealthCountLabel
@onready var death_icon: Label = $DeathIcon
@onready var next_round_btn: Button = $NextRoundBtn
@onready var death_sound_player: AudioStreamPlayer3D = $DeathSoundPlayer
@onready var buy_tower_btns = [
	[$BuyBoxTower, preload("res://towers/BoxTower.tscn"), 5],
]

var round_nodes: Array[Node]
var next_round_index: int = 0
var round_prize: int = 0
var sounds_playing: int = 0
var in_round: bool = true

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
	if in_round and sounds_playing == 0 and guys.get_child_count() == 0:
		if health <= 0:
			call_deferred("on_game_over")
			return
		in_round = false
		next_round_btn.disabled = false
		tower_dragger.enable_pickup = true
		update_money(money + round_prize)
		status_label.text = "Prepare for round " + str(next_round_index + 1) + "..."

	if tower_dragger.held_node == null:
		next_round_btn.disabled = in_round
	else:
		next_round_btn.disabled = true

func next_round():
	SoundFX.click_sound.play()
	if next_round_index >= len(round_nodes):
		return

	var round_node = round_nodes[next_round_index]
	for guy in round_node.get_children():
		guy.reparent(guys)
	if round_node.has_meta("prize"):
		round_prize = round_node.get_meta("prize")
	else:
		round_prize = 0
	next_round_index += 1
	status_label.text = "Round " + str(next_round_index)
	in_round = true
	next_round_btn.disabled = true
	tower_dragger.enable_pickup = false

func update_money(new_money: int):
	money = new_money
	money_count_label.text = str(money) + "¢"
	for btn in buy_tower_btns:
		btn[0].disabled = btn[2] > money

func update_health(new_health: int):
	health = new_health
	health_count_label.text = str(health)
	death_icon.visible = health <= 0

func spawn_tower(res: PackedScene, price: int):
	SoundFX.coin_sound.play()
	update_money(money - price)
	var tower = res.instantiate()
	tower.guys = guys
	tower.bullets = bullets
	towers.add_child(tower)
	tower_dragger.pick_up(tower)

func on_body_entered_death_area(body: Node3D):
	if not body.get_meta("is_guy", false):
		return

	var sound = death_sound_player.duplicate()
	death_area.add_child(sound)
	sound.connect("finished", func finished():
		sounds_playing -= 1
		sound.queue_free())
	sounds_playing += 1
	sound.play()
	update_health(health - 1)
	body.queue_free()

func on_game_over():
	get_tree().change_scene_to_packed(game_over_scene)
