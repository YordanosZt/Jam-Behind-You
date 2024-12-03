extends StaticBody2D

@onready var glass_hit = $GlassHit

var life: int = 3

func take_damage():
	life -= 1
	
	glass_hit.play()
	
	if life <= 0:
		queue_free()
