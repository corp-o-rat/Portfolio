extends Line2D
func _ready():
	await get_tree().create_timer(10).timeout
	var tween1 = get_tree().create_tween()
			
	tween1.set_parallel(true)

	tween1.tween_property(self, "modulate:a", 0, 4).set_ease(1)
	await tween1.finished
	queue_free()
