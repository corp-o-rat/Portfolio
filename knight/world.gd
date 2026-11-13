extends Node2D
const BIRD = preload("uid://bhmhlkersnuni")

func _process(delta):
	if randi_range(0, 1000) == 10:
		var b = BIRD.instantiate()
		b.position.x = - 2000
		b.position.y = randi_range(-300, -100)
		add_child(b)
		b.modulate = Color.from_hsv(randf(), 1, 1)
		
