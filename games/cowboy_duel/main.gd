extends Node2D

@export var player_scene: PackedScene

@onready var spawns: Node2D = $Spawns
@onready var players: Node2D = $Players
@onready var center: Marker2D = $Center
@onready var killfeed: VBoxContainer = $CanvasLayer/KillFeed
@onready var scoreboard: VBoxContainer = $CanvasLayer/ScoreBoard

var score_scene: PackedScene = preload("res://games/cowboy_duel/ui/score.tscn")
var kill_scene: PackedScene = preload("res://games/cowboy_duel/ui/kill.tscn")

func _ready() -> void:
	if not player_scene:
		Debug.log("No player scene selected")
		return
	for i in Game.players.size():
		var spawn_pos = spawns.get_child(i).global_position
		var center_pos = center.global_position
		var facing_dir = (center_pos - spawn_pos).normalized()
		var player_data = Game.players[i]
		var player_inst = player_scene.instantiate()
		player_inst.global_position = spawn_pos
		players.add_child(player_inst)
		player_inst.setup(player_data)
		player_inst.set_facing(facing_dir)
		
		var score_inst = score_scene.instantiate()
		score_inst.setup(player_data)
		scoreboard.add_child(score_inst)

		player_inst.connect("on_death", on_player_death)
		player_inst.connect("on_kill", add_kill)

func on_player_death():
	var players = get_alive_players()
	if players.size() == 1:
		Game.end_game()

func get_alive_players():
	return players.get_children().filter(func(p): return p.alive)

func add_kill(killer: PlayerData, victim: PlayerData):
	var kill_inst = kill_scene.instantiate()
	kill_inst.setup(killer, victim)
	killfeed.add_child(kill_inst)
