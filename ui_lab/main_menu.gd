extends Control


var _game_started := false
@onready var start_game: Button = %StartGame
@onready var settings: Button = %Settings
@onready var quit: Button = %Quit

func _ready() -> void:
	start_game.pressed.connect(_on_start_game_pressed)
	quit.pressed.connect(func (): get_tree().quit())
	settings.pressed.connect(func(): get_tree().change_scene_to_file("res://ui_lab/settings.tscn"))
	start_game.grab_focus()


func _on_start_game_pressed():
	if _game_started:
		return
	for test_player in Game.test_players:
		var player_data = PlayerData.new()
		player_data.input = test_player.input
		player_data.color = test_player.color
		Game.players.append(player_data)
	Game.load_game("res://common/ui/game_info/game_info.tscn")
	_game_started = true
