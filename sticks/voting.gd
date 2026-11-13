extends Control
var old = -1
var this = false
signal gambled
var sticks = {}
var made = false
var buttons = []
var selected = -1
var basesticks = [-1]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_viewport_rect().size)
	%Submit.disabled = true
	$"../../..".connect("next", readytorecieve)
	
	size = get_viewport_rect().size * 0.5
	print(size)
	position = (get_viewport_rect().size - size) * 0.5
	pivot_offset = size * 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if this:
		#print(%StickHolder.get_children())
		for child in %StickHolder.get_children():
			child.connect("stickdata", data)
			
		this = false
	
	if sticks.size() == Global.num_sticks:
		
		if not made:
			makeops()
func readytorecieve():
	this = true
	
func data(name, texture, stick):
	sticks[name] = texture
	basesticks.append(stick)
func ttoggled(thing, num):
	
	var inum = int(num)
	
	
	if old != inum:
		%Submit.disabled = false
		
		if old != -1:
			
			buttons[old].button_pressed = false
			
	old = inum

	selected = basesticks[inum +1]
func makeops():
	%Submit.size.y = (get_viewport_rect().size.y / 2)/(sticks.size())
	var V = %opts
	for i in range(sticks.size()):
		var H = HBoxContainer.new()
		H.alignment = BoxContainer.ALIGNMENT_CENTER
		H.name = str(V.get_children().size())
		
		
		V.add_child(H)
		var T = TextureButton.new()
		buttons.append(T)
		T.texture_normal = preload("uid://dvbm032y4vqec")
		T.texture_disabled = preload("uid://dvbm032y4vqec")
		T.texture_pressed = preload("uid://drxa3lk2oguhm")
		T.texture_hover = preload("uid://drxa3lk2oguhm")
		T.toggle_mode = true
		T.custom_minimum_size.y = (get_viewport_rect().size.y / 2)/(sticks.size())
		T.unique_name_in_owner = true
		T.name = "T"
		T.stretch_mode = TextureButton.STRETCH_SCALE
		T.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		T.ignore_texture_size = true
		
		T.toggled.connect(ttoggled.bind(i))
		H.add_child(T)
		var L = Label.new()
		L.text = sticks.keys()[i]
		L.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		L.add_theme_font_size_override("font_size", 32)
		L.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		L.set_anchors_preset(PRESET_CENTER_LEFT)
		L.position.x += 30
		T.add_child(L)
		var TR = TextureRect.new()
		TR.texture = sticks.values()[i]
		TR.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		TR.custom_minimum_size = Vector2(64, 64)
		TR.set_anchors_preset(PRESET_CENTER)
		T.add_child(TR)
	made = true



func _on_submit_pressed() -> void:
	self.visible = false
	
	emit_signal("gambled", selected)
