extends Node2D

@export var bullet: PackedScene

@onready var fire_delay = $FireDelay
@onready var firing_point = $FiringPoint
@onready var audio = $AudioStreamPlayer2D

var can_shoot: bool = true

func _process(_delta):
	if should_shoot():
		shoot()


func should_shoot() -> bool:
	return can_shoot and Input.is_action_pressed("shoot")

func shoot():
	# Shoot
	var _bullet = bullet.instantiate()
	add_child(_bullet)
	_bullet.global_position = firing_point.global_position
	_bullet.global_rotation = firing_point.global_rotation
	
	audio.pitch_scale = randf_range(0, 2)
	audio.play()
	
	can_shoot = false
	fire_delay.start()


func _on_fire_delay_timeout():
	can_shoot = true
