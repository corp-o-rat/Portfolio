extends Control
var slots = {"HelmetSlot": Items.helmet, "ChestplateSlot": Items.chestplate, "GauntletSlot": Items.gauntlets, "LeggingsSlot": Items.leggings, "BootsSlot": Items.boots, "ItemSlot": Items.item,}
var full = {"HelmetSlot": Items.helmet, "ChestplateSlot": Items.chestplate, "GauntletSlot": Items.gauntlets, "LeggingsSlot": Items.leggings, "BootsSlot": Items.boots, "ItemSlot": Items.item}
var empty = {"HelmetSlot": Items.empty_helmet, "ChestplateSlot": Items.empty_chestplate, "GauntletSlot": Items.empty_gauntlets, "LeggingsSlot": Items.empty_leggings, "BootsSlot": Items.empty_boots, "ItemSlot": Items.empty_item}
const TOOLTIP = preload("uid://b2ix7dwthj38p")
var over = null

func _ready():
	for item in get_tree().get_nodes_in_group("hover"):
		item.connect("mouse_entered", hover.bind(item))
		
		
		item.connect("mouse_exited", unhover.bind(item))
	update()
		
func update():
	for item in slots:
		if slots[item]:
			self.get_node("H/M/V/" + item).get_child(0).texture = slots[item][0]
			for i in range(len(slots[item][1])):
				
				%Player.get_node("Body/" + slots[item][1][i]).frame_coords.x = slots[item][2]
		
func swap(item):
	
	if slots[item.name] == empty[item.name]:
		slots[item.name] = full[item.name]
		
	else:
		slots[item.name] = empty[item.name]
	update()
func _process(delta):
	if Input.is_action_just_pressed("leftclick"):
		if over:
			swap(over)
			
func hover(item):
	over = item
	if slots[item.name][-1]:
			
			
		var tt = TOOLTIP.instantiate()
		tt.get_node("TextureRect/Label").text = slots[item.name][-1]
		tt.name = "ToolTip"
		add_child(tt)
func unhover(item):
	over = null
	if slots[item.name]:
		
		for child in get_children():
			if child.name == "ToolTip":
				remove_child(child)
