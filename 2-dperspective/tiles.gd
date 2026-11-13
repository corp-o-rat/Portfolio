extends Node2D
@onready var city = $city


var height = 10
var length = 10
var tile = Vector2i(0,0)
var source = 0

# to add more buildings, just add them here
var tile_scenes = {
	"0_0": preload("uid://bklkxq00851ld"),
	"2_0": preload("uid://cehn84ie68tey"),
	"4_0": preload("uid://b08klsp65y1fq"),
	"6_0": preload("uid://cvktvwvju1ot1"),
	"8_0": preload("uid://cwdh2ubxmomc1"),
}
func _ready():
	replace()
func replace():
	var spawn_scenes_pos: Array
	var spawn_scenes_preload: Array
	for i in tile_scenes.keys():
		var is_x_coord = true
		var x_coord_to_add: String
		var y_coord_to_add: String
		for character in i:
			if character == "_":
				is_x_coord = false
				continue
			if is_x_coord:
				x_coord_to_add += character
			else:
				y_coord_to_add += character
		spawn_scenes_pos.append(Vector2i( int(x_coord_to_add), int(y_coord_to_add) ))
		spawn_scenes_preload.append(tile_scenes[i])
		
	if spawn_scenes_pos.size() != 0:
		for tile in city.get_used_cells():
			
			if spawn_scenes_pos.has(city.get_cell_atlas_coords(tile)):
				
				var data = city.get_cell_tile_data(tile)
				
				var image = data.get_custom_data("Texture")
				

				var sprite = Sprite2D.new()
				var atlas_texture = AtlasTexture.new()
				var texture = spawn_scenes_preload[image]
				atlas_texture.atlas = texture
				atlas_texture.region = Rect2(0, 0, 32, 32)
				sprite.texture = atlas_texture
				sprite.set_script(preload("res://perspective.gd"))
				sprite.global_position = (tile * 32) + Vector2i(16, 16)
				#city.set_cell(tile, -1)
				
				add_child(sprite)
