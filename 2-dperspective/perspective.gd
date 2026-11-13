extends Sprite2D
@onready var player = $"../../Player"
var self_pos = self.position
var larger
var frametxt = "res://external/Perspective.txt"
var disty : int
var distx : int
var atlas_texture: AtlasTexture = texture
func perspective(disty, distx):
	
	if distx < 16 and disty < 16:
		z_index = distx + disty + 200
	if distx > 16 and disty < 16:
		z_index = -distx + disty + 200
	if distx < 16 and disty > 16:
		z_index = distx - disty + 200
	if distx > 16 and disty > 16:
		z_index = -distx - disty + 200

		
		

		
	if disty >= 0 and disty <= 32:
		if distx >= 0 and distx <= 32:
			atlas_texture.region = Rect2(Vector2(distx * 64, disty * 64),  Vector2(64, 64))
		if distx <= 0:
			atlas_texture.region = Rect2(Vector2(0, disty * 64),  Vector2(64, 64))
		if distx >= 32:
			atlas_texture.region = Rect2(Vector2(2048, disty * 64),  Vector2(64, 64))
	if disty <= 0:
		if distx >= 0 and distx <= 32:
			atlas_texture.region = Rect2(Vector2(distx * 64, 0),  Vector2(64, 64))
		if distx <= 0:
			atlas_texture.region = Rect2(Vector2(0, 0),  Vector2(64, 64))
		if distx >= 32:
			atlas_texture.region = Rect2(Vector2(2048, 0),  Vector2(64, 64))
	if disty >= 32:
		if distx >= 0 and distx <= 32:
			atlas_texture.region = Rect2(Vector2(distx * 64, 2048),  Vector2(64, 64))
		if distx <= 0:
			atlas_texture.region = Rect2(Vector2(0, 2048),  Vector2(64, 64))
		if distx >= 32:
			atlas_texture.region = Rect2(Vector2(2048, 2048),  Vector2(64, 64))
func ysort():
	print(get_parent().get_child_count())
func _ready():
	distx = int(player.position.x) / 5 - int(self.position.x / 5) + 16
	disty = int(player.position.y) / 5 - int(self.position.y / 5) + 16
	
	perspective(disty, distx)



func _process(_delta):
	distx = int(player.position.x / 5) - int(self.position.x / 5) + 16
	disty = int(player.position.y / 5) - int(self.position.y / 5) + 16
	if player.velocity:
		perspective(disty, distx)
		#print(disty)
		#print(distx)
	
			
