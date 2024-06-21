extends "res://ui_lab/settings/text_edit_dialog.gd"


func _on_confirmed() -> void:
	var game_info = Game.get_current_game_info() as GameInfo
	game_info.description = text_edit.text
	ResourceSaver.save(game_info, Game.get_current_game_path() + "/info.tres")


func _on_canceled() -> void:
	var game_info = Game.get_current_game_info() as GameInfo
	text_edit.text = game_info.description
	_on_text_changed()
