extends CharacterBody2D

@export var speed: int = 500
@export var acceleration: int = 2000

@onready var hitbox : Area2D = $Hitbox
@onready var sprite : Sprite2D = $Crosshair
@onready var original_pos : Vector2 = self.position

var curr_speed: int = 0
var move_input: Vector2 = Vector2.ZERO: set = set_move_input

func _physics_process(delta: float) -> void:
	var target_velocity = curr_speed * move_input
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	
	move_and_slide()

func set_move_input(direction: Vector2) -> void:
	move_input = direction

func aim() -> void:
	curr_speed = speed
	show()

func cancel_aim() -> void:
	hide()
	reset()

func shoot() -> Array[Area2D]:
	hide()
	reset()
	return hitbox.get_overlapping_areas()

func reset() -> void:
	curr_speed = 0
	position = original_pos
	velocity = Vector2.ZERO

func update_color(data: PlayerData) -> void:
	sprite.modulate = data.primary_color
