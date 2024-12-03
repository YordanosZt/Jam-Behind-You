extends Node2D

@onready var level_completed_label = $CanvasLayer/LevelCompletedLabel

@export var next_level: PackedScene

func _ready():
	Events.level_completed.connect(_on_level_complete)
	Events.game_over.connect(_on_game_over)
	
	if next_level == null:
		next_level = load("res://Scenes/game_completed.tscn")

func _process(delta):
	if Input.is_action_just_pressed('restart'):
		Events.game_over.emit()

func _on_level_complete():
	level_completed_label.visible = true
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_packed(next_level)

func _on_game_over():
	get_tree().reload_current_scene()
