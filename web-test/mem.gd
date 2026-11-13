extends Control
@export var checktime = 0.2
var length = 1
var target = 0
var guessing = false
var orig = [0, 1, 2, 3]
var opti = [0, 1, 2, 3]
var guess = []
var pics = [preload("res://blue.png"), preload("res://green.png"), preload("res://brown.png"), preload("res://red.png")]
var life = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	%Game.visible = false
	%APs.visible = false
	randomize()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%Health.text = str(life) + " Mistakes Left   "
	%Lives.value = 3 - life
	if guessing:
		if Input.is_action_just_pressed("SU"):
			
			%OPs.get_child(target).get_child(1).value = 0
			if target < orig.size() - 1:
				
				target += 1
			else:
				target = 0
			%OPs.get_child(target).get_child(1).value = 1
		if Input.is_action_just_pressed("SD"):
			
			%OPs.get_child(target).get_child(1).value = 0
			if target > 0:
				
				target -= 1
			else:
				target = orig.size() - 1
			%OPs.get_child(target).get_child(1).value = 1
func randomize_ops():
	
	%OPs.get_child(0).get_child(1).value = 1
	
	
	%ProgressBar.visible = false
	%APs.visible = true
	var APs = get_tree().get_nodes_in_group("APs")
	var OPs = get_tree().get_nodes_in_group("OPs")
	
	for pic in range(APs.size()):
		
		var current = APs[pic]
		
		current.visible = true
	var a = 0
	for pic in range(OPs.size()):
		var current = OPs[pic]
		var tween = create_tween()
		tween.tween_property(current.get_child(0), "modulate:a", 0, 0.2)
		await tween.finished
		current.get_child(0).texture_normal = null
		a += 1
	await a == OPs.size()
	guessing = true
		
		#select_aps()
func memorize_ops():
	
	if length == 1:
		orig = [0, 1, 2, 3]
		guess = [-1]
		orig.shuffle()
		for i in range(orig.size() - 1):
			orig.pop_back()
	var deleted = 0
	target = 0
	
	orig.shuffle()
	
	

	for i in range(get_tree().get_nodes_in_group("OPs").size()):
		%OPs.get_child(0).free()
		
		deleted += 1
		
	await deleted == get_tree().get_nodes_in_group("OPs").size() + 1
	
	print(orig.size())
	if orig.size() != get_tree().get_nodes_in_group("OPs").size():
		for i in range(orig.size()):
			var option = VBoxContainer.new()
			option.add_to_group("OPs")
			
			
			%OPs.add_child(option)
			option.name = "Op" + str(i + 1)
			option.owner = self
			
			
			option.unique_name_in_owner = true
			
			var optex = TextureButton.new()
			
			
			optex.connect("pressed", _on_texture_rect_pressed.bind(option.name))
			optex.connect("mouse_entered", _on_texture_rect_mouse_entered.bind(option.name))
			optex.connect("mouse_exited", _on_texture_rect_mouse_exited.bind(option.name))
			optex.ignore_texture_size = true
			
			optex.custom_minimum_size = Vector2(100, 100)
			optex.stretch_mode = TextureButton.STRETCH_SCALE
			optex.texture_normal = pics[orig[i]]
			option.add_child(optex)
			
			var opsel = ProgressBar.new()
			opsel.max_value = 1
			opsel.step = 1
			opsel.show_percentage = false
			option.add_child(opsel)
			var opl = Label.new()
			opl.text = str(i)
			opl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			option.add_child(opl)
		print(orig)
		
	%ProgressBar.visible = true
	%ProgressBar.value = 100
	var tween = create_tween()
	tween.tween_property(%ProgressBar, "value", 0, 5)
	await tween.finished
	randomize_ops()

#func select_aps():
	


func _on_start_pressed() -> void:
	%Start.visible = false
	
	%Game.visible = true
	memorize_ops()
	


func _on_texture_rect_mouse_entered(str):
	if guessing:
		
		var origin : Node = get_node("%" + str)
		origin.get_child(1).value = 1

func _on_texture_rect_mouse_exited(str):
	if guessing:
		var origin : Node = get_node("%" + str)
		
		if not origin.is_in_group("OPs") or origin != origin.get_parent().get_child(target):
			origin.get_child(1).value = 0
		



	


func _on_texture_rect_pressed(str):
	if guessing:
		if str.contains("Pic"):
			if target <= orig.size() - 1:
				var origin_node : Node = get_node("%" + str)
				var origin_pic = get_node("%" + str).get_child(0).texture_normal
				var target_node : Node = %OPs.get_child(target)
				var target_pic = %OPs.get_child(target).get_child(0).texture_normal
				
				#if target_node.get_child(0).modulate.a != 0:
					#origin_node.get_child(0).texture_normal = target_pic
					#
					#
				#else:
					#
					#origin_node.visible = false
				guess[target] = opti[int(str.replace("Pic", "")) - 1]
				print(guess[target])
				target_node.get_child(0).texture_normal = origin_pic
				target_node.get_child(0).modulate.a = 100
				target_node.get_child(1).value = 0
				var a = false
				for pic in range(get_tree().get_nodes_in_group("OPs").size()):
					
					if not a:
						if not %OPs.get_child(pic).get_child(0).texture_normal:
							
							target = pic
							
							if target == orig.size():
								target = 0
							a = true
				if not a:
					if target < orig.size() - 1:
						target += 1
					
					else:
					
						target = 0
					print("finalized")
				%OPs.get_child(target).get_child(1).value = 1
				a = false
				
				
		elif str.contains("Op"):
		
			var origin_pic : Node = get_node("%" + str)
				
			
			var finished = false
			if origin_pic.get_child(0).texture_normal:
				for pic in range(get_tree().get_nodes_in_group("APs").size()):
					if not finished:
						
						
						
						origin_pic.get_child(0).texture_normal = null
						origin_pic.get_child(0).modulate.a = 0
						finished = true
						%OPs.get_child(target).get_child(1).value = 0
						var a = false
						for p in range(get_tree().get_nodes_in_group("OPs").size()):
							
							if not a:
								if not %OPs.get_child(p).get_child(0).texture_normal:
									
									target = p
									if target == orig.size():
										target = 0
									a = true
						%OPs.get_child(target).get_child(1).value = 1
			else:
				%OPs.get_child(target).get_child(1).value = 0
				target = int(str.replace("Op", "")) - 1
				%OPs.get_child(target).get_child(1).value = 1


func _on_texture_button_pressed():
	%APs.visible = false
	print("Checking...")
	if guessing:
		var a = false
		var num = 0
		for pic in range(get_tree().get_nodes_in_group("OPs").size()):
			
			if not a:
				if not %OPs.get_child(pic).get_child(0).texture_normal:
					
					print("Make sure all slots are filled")
					
					a = true
				else:
					num += 1
			else:
				num = 0
		
		if num == orig.size():
			test_pics()
			
func test_pics():
	
	print(orig)
	print(guess)
	guessing = false
	var num1 = 0
	
	var incorrect = false
	for pic in range(orig.size()):
		%OPs.get_child(pic).get_child(1).value = 1
		
		if orig[pic] == guess[pic]:
			
			%OPs.get_child(pic).get_child(1).modulate = Color("green")
			print("Correct")
		else:
			%OPs.get_child(pic).get_child(1).modulate = Color("red")
			incorrect = true
		
		await get_tree().create_timer(checktime).timeout
		num1 += 1
		
	await num1 == orig.size()
	if incorrect:
		incorrect = false
		if life > 1:
			life -= 1
			soft_reset()
		else:
			%Lives.value = 3
			print("Failure")
	else:
		win()
		
func win():
	%Victory.visible = true
	
func soft_reset():
	%APs.visible = true
	target = 0
	var num2 = 0
	guessing = true
	var OPs = get_tree().get_nodes_in_group("OPs")
	var APs = get_tree().get_nodes_in_group("APs")
	for pic in range(OPs.size()):
		var current = OPs[pic]
		
		
		current.get_child(0).texture_normal = null
		current.get_child(0).modulate.a = 0
		if current != %Op1:
			current.get_child(1).value = 0
		current.get_child(1).modulate = Color("white")
		await get_tree().create_timer(0.2).timeout
		num2 += 1
	await num2 == OPs.size()
	
	for pic in range(APs.size()):
		
		var current = APs[pic]
		current.get_child(0).texture_normal = pics[opti[pic]]
		current.visible = true


func _on_play_again_pressed():
	addDificulty()
	guessing = false
	%Victory.visible = false
	var OPs = get_tree().get_nodes_in_group("OPs")
	for pic in range(OPs.size()):
		var current = OPs[pic]
		
		current.get_child(1).value = 0
		current.get_child(1).modulate = Color("white")
		
	memorize_ops()
	
	
	
func addDificulty():
	length += 1
	guess.clear()
	orig.clear()
	for i in range(length):
		var num = randi_range(0, 3)
		orig.append(num)
		guess.append(-1)
	
	
	
	
	
