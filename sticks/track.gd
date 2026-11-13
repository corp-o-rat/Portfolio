extends Node2D
signal firstchange
signal go
signal next
var tsk = []
const LABEL_WIDTH = 120 
@export var num_sticks = 2 
@onready var stk = preload("uid://c811ypummbdny")
@onready var first = 0
@onready var H = $C/UI/H
var lineup = []
var positions = {}
var sorted_keys = []
var labels = []
var tween_running = false
var tween_runnable = false
var tween_jobs = []
var goable = false
var finished = 0
var winners = []
func _on_river_body_entered(body: Node2D) -> void:
	print(body)
func _ready() -> void:
	$C/UI/Voting.connect("gambled", goble)
	Global.num_sticks = num_sticks
	for t in range(num_sticks):
		var txt = ""
		var label = Label.new()

		txt = "Waiting"
		var bg = TextureRect.new()
		bg.size.x = LABEL_WIDTH
		bg.size.y = 60
		
		bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg.texture = preload("uid://drxa3lk2oguhm")
		bg.z_index = -1
		bg.set_anchors_preset(Control.PRESET_CENTER)
		H.add_child(bg)
		label.text = txt
		label.custom_minimum_size = Vector2(LABEL_WIDTH, 30)
		label.set_anchors_preset(Control.PRESET_TOP_LEFT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		labels.append(label)
		
		bg.add_child(label)
	for i in range(num_sticks):
		var stick = stk.instantiate()
		stick.position = Vector2(-22, 630)
		%StickHolder.add_child(stick)
		
		
		lineup.append(stick)
		positions[i] = floor(lineup[i].global_position.x)
	emit_signal("next")
	
	tsk = sort_dictionary_by_value_descending(positions)
	while not goable:
		await get_tree().process_frame
	await get_tree().create_timer(3).timeout
	emit_signal("go")
	
	tween_runnable = true
	for s in range(lineup.size()):
		positions[s] = floor(lineup[s].global_position.x)
	sorted_keys = sort_dictionary_by_value_descending(positions)
	tsk = sorted_keys
	
	places()
	
		
func _process(delta: float) -> void:
	if tween_runnable == true:
		for s in range(lineup.size()):
		
			positions[s] = floor(lineup[s].global_position.x)
		
	
		sorted_keys = sort_dictionary_by_value_descending(positions)
	
		if tsk != sorted_keys:
			places()
	
	
func goble(guess):
	goable = true
	print(str(guess) + " was guessed")
	guess.get_child(2).visible = true
	
		
	#$C/UI/H/first.text = text
	

	
func sort_dictionary_by_value_descending(dictionary_to_sort: Dictionary) -> Array:

	var keys_array: Array = dictionary_to_sort.keys()

	keys_array.sort_custom(func(a, b):

		return dictionary_to_sort[b] < dictionary_to_sort[a] #
	)

	return keys_array
func places():
	
			
	for i in range(tsk.size()):
		
		
		var stick_index = sorted_keys[i]
		var stick = labels[stick_index]
	
		stick.text = str(i + 1) + " : " + lineup[stick_index].name + "    "
		
		
		var os = labels[tsk[i]]
		var tpos = i * LABEL_WIDTH
		var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(stick.get_parent(), "position:x", tpos, 0.3)
	
		
		
		if first != sorted_keys[0]:
			emit_signal("firstchange", lineup, sorted_keys[0])
			first = sorted_keys[0]
		tsk = sorted_keys
func end(winners):
	$C/UI/H.visible = false
	$C/UI/endscreeen.visible = true
	for opponent in winners:
		var Hbox = HBoxContainer.new()
		$C/UI/endscreeen.get_child(0).add_child(Hbox)
		var Name = Label.new()
		Name.text = opponent
		Hbox.add_child(Name)
		var Placement = Label.new()
		Placement.text = "Placement: " + str(winners.find(opponent))
		Hbox.add_child(Placement)
		

func _on_area_2d_body_entered(body):
	print(body.name + " Is the Winner!")
	winners.append(body.name)
	finished += 1
	if finished == num_sticks:
		end(winners)
	
