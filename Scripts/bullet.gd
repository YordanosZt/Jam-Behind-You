extends Area2D

var direction = 1
var distance = 0

const BULLET_SPEED = 250
const RANGE = 500.0

func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	translate(direction * BULLET_SPEED * delta)
	
	distance += BULLET_SPEED * delta
	if distance >= RANGE:
		queue_free()

func _on_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage()
		queue_free()
