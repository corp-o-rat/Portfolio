extends CharacterBody2D
func _physics_process(delta):
	
	velocity = Vector2(50, 0)
	move_and_slide()
