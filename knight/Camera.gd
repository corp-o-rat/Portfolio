extends Camera2D
@onready var player = %Player


func _process(delta):
	#self.position = lerp(self.position, player.position, 0.5)
	self.position = player.position
