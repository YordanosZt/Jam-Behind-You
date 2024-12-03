extends Area2D




func _on_body_entered(body):
	Events.game_over.emit()
