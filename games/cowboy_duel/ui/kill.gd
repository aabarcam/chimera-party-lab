extends HBoxContainer

@onready var killer_rect: ColorRect = $Killer
@onready var victim_rect: ColorRect = $Victim
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

var _killer_data: PlayerData
var _victim_data: PlayerData

func _ready() -> void:
	killer_rect.color = _killer_data.primary_color
	victim_rect.color = _victim_data.primary_color
	timer.connect("timeout", _on_timer_timeout)

func setup(killer: PlayerData, victim: PlayerData) -> void:
	_killer_data = killer
	_victim_data = victim

func _on_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_callback(queue_free)
