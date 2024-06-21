extends CharacterPlayer

signal on_death
signal on_kill(killer, victim)

@export var speed: int = 500
@export var acceleration: int = 2000
@export var roll_speed: int = 1000

@onready var gun: Node2D = $Gun

@onready var hitbox: Area2D = $Hitbox
@onready var sprite_node: Node2D = $Pivot
@onready var colorable_sprite_node: Node2D = $Pivot/Colorable
@onready var roll_time: Timer = $RollTime
@onready var roll_cd_timer: Timer = $RollCdTimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var roll_available: bool = true
var rolling: bool = false
var alive: bool = true
var aiming: bool = false
var curr_speed: int = speed
var next_frame_vel: Vector2 = Vector2.ZERO
var facing: Vector2 = Vector2.ZERO: set = set_facing


func setup(player_data: PlayerData) -> void:
	super.setup(player_data)
	gun.update_color(player_data)

func _ready() -> void:
	roll_time.timeout.connect(_on_roll_time_timeout)
	roll_cd_timer.timeout.connect(_on_roll_cd_timer_timeout)
	anim_player.play("idle")

func _process(delta: float) -> void:
	if sign(sprite_node.scale.x) != sign(facing.x) and facing.x != 0:
		sprite_node.scale.x *= -1
	if Input.is_action_just_pressed(action_a) and not rolling and roll_available:
		roll()
	if Input.is_action_just_pressed(action_b):
		if aiming:
			shoot()
		else:
			aim()

func _physics_process(delta: float) -> void:
	var move_input = Input.get_vector(
		move_left,
		move_right,
		move_up,
		move_down
	)
	
	if move_input != Vector2.ZERO and not rolling:
		facing = move_input
	
	gun.set_move_input(move_input)
	if not rolling:
		var target_velocity = curr_speed * move_input
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	move_and_slide()

func aim() -> void:
	aiming = true
	curr_speed = 0
	gun.aim()

func cancel_aim() -> void:
	curr_speed = speed
	aiming = false
	gun.cancel_aim()

func shoot() -> void:
	aiming = false
	curr_speed = speed
	var hit_areas = gun.shoot()
	var cowboys = get_tree().get_nodes_in_group("cowboys")
	var hit_cowboys = cowboys.filter(func(cowboy): return cowboy.hitbox in hit_areas)
	for cowboy in hit_cowboys:
		if cowboy == self:
			data.local_score -= 50
		else:
			data.local_score += 10
		kill(data, cowboy.data)
		cowboy.die()

func roll() -> void:
	if aiming:
		cancel_aim()
	roll_available = false
	rolling = true
	print("Rolling", rolling)
	velocity = facing * roll_speed
	roll_cd_timer.start()
	roll_time.start()

func die() -> void:
	alive = false
	on_death.emit()
	queue_free()

func kill(killer: PlayerData, victim: PlayerData) -> void:
	on_kill.emit(killer, victim)

func update_color() -> void:
	colorable_sprite_node.modulate = data.primary_color

func set_facing(value: Vector2):
	facing = value

func _on_roll_time_timeout():
	print("end rolling", rolling)
	roll_time.stop()
	velocity = Vector2.ZERO
	rolling = false

func _on_roll_cd_timer_timeout() -> void:
	roll_available = true
