extends Control
@onready var speedlabel = %Speed
@onready var player = %Player

func _ready():
	pass
func _process(_delta):

	speedlabel.text = str(floor(player.velocity.length())) + " MPH"
	
	


func _on_player_traction_change(traction):
	
	
	$M/V/H/traction.text = "Traction: " + str(traction)
	if traction != 40:
		$M/V/H/wheels.texture = preload("uid://cqv7mf8h1m8ro")
	else:
		$M/V/H/wheels.texture = preload("uid://l2ava0oalg0v")
