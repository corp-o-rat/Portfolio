extends Camera2D
const LOOKAHEAD_DISTANCE = 15


@onready var player = %Player


func _ready() -> void:
	global_position = player.global_position

func _physics_process(_delta):
	var target_pos = player.global_position
	if player.velocity.length() > 0.1:
		var look_dir = player.velocity.normalized()
		target_pos += look_dir * LOOKAHEAD_DISTANCE * (player.velocity.length()/30)
	var camera_position = lerp(global_position, target_pos, 0.05)
	global_position = camera_position
	
