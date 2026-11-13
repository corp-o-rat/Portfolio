extends CharacterBody2D
var health = 1000

func hurt(dmg):
	health -= dmg
	$AnimationPlayer.play("hit")
	update()
	if health <= 0:
		self.get_parent().remove_child(self)
func update():
	$ProgressBar.value = health
