extends Node2D
var player = false
var opened = false
var stuck = false
func _process(delta):
	if player:
		if Input.is_action_just_pressed("action"):
			if opened:
				close()
			else:
				open(sign(%Player.position.x - position.x))
func open(dir):
	opened = true
	if dir > 0:
		$dooranims.play("openR")
		
	else:
		$dooranims.play("openL")
func close():
	if not stuck:
		opened = false
		$dooranims.play("Close")
		$doorbox/CollisionShape2D.disabled = false
	




func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$Label.visible = true
		player = true


func _on_area_2d_body_exited(body):
	if opened:
		
		$doorbox/CollisionShape2D.set_deferred("disabled", false)
		$dooranims.play("Close")
	if body.name == "Player":
		$Label.visible = false
		player = false
	
	


func _on_doorarea_body_entered(body):
	stuck = true
	



func _on_doorarea_body_exited(body):
	stuck = false
