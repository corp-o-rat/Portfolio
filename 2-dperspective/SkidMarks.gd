extends Node2D

@onready var player = $".."

var current_trail: Line2D = null
var driftin = false

func _process(delta):
	if driftin and current_trail:
		current_trail.add_point(self.global_position)
		
		
		
func drift():
	current_trail = Line2D.new()
	current_trail.default_color = Color("#000")
	current_trail.width = 1
	current_trail.modulate.a = 0.5
	current_trail.set_script(preload("uid://c6nlgtrp1i3yp"))
	current_trail.top_level = true
	current_trail.show_behind_parent = true
	self.add_sibling(current_trail)
	current_trail.add_point(self.global_position)
	driftin = true
func not_drift():
	driftin = false
	if current_trail:
		
		current_trail = null
		



func _on_node_2d_drift(drifting):
	if drifting and not driftin:
		drift()
	elif not drifting:
		not_drift()
