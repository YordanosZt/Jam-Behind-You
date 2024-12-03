extends Area2D

@export var player: CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction: float
var begin_following: bool = false
var count = 0
var player_record: Dictionary = Dictionary()
var original_position: Vector2

@onready var delay_timer = $DelayTimer
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	original_position = global_position
	Events.level_completed.connect(_on_level_complete)

func _process(delta):
	if not begin_following: return
	
	animated_sprite.visible = true
	collision_shape_2d.disabled = false
	
	player_record = player.player_record
	
	get_recording()

func get_recording():
	count += 1
	var test = player_record.get(count)

	if test != null:
		global_position = test[0]
		animated_sprite.flip_h = test[1]
		animated_sprite.play(test[2])

func _on_delay_timer_timeout():
	begin_following = true

func _on_body_entered(body):
	Events.game_over.emit()

func _on_level_complete():
	queue_free()
