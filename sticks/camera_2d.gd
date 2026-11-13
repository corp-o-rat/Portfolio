extends Camera2D

const LOOKAHEAD_DISTANCE = 15


@onready var player = null


func _ready() -> void:
	global_position = Vector2(0, 0)
	$"..".firstchange.connect(on_first_changed)
func _physics_process(_delta):
	var target_pos = Vector2.ZERO
	if player:
		target_pos = player.global_position
		
		var look_dir = player.velocity.normalized()
		target_pos += look_dir * LOOKAHEAD_DISTANCE * (player.velocity.length()/30)
		
		
	else:
		target_pos = Vector2(960, 540)
	var camera_position = lerp(global_position, target_pos, 0.05)
	global_position = camera_position
func on_first_changed(lineup, first):
	
	player = lineup[first]
	
