extends Area2D

@onready var audio = $AudioStreamPlayer2D


func _on_body_entered(body):
	audio.play()
	Events.level_completed.emit()
