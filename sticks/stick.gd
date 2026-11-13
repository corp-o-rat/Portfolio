extends CharacterBody2D
var floating = false
var speed = 0
signal stickdata
var max_speed = 5000
var dir = Vector2(1, 0)
var blinking = false
var accel = 100
var target = Vector2.ZERO
var rng = RandomNumberGenerator.new()
@onready var bottomp = get_parent().get_parent().get_node("BottomBorder").points
@onready var topp = get_parent().get_parent().get_node("TopBorder").points
@onready var checkpoints = get_parent().get_parent().get_node("Line2D").points
var distance = INF
var close = false
var pt = Vector2.INF
var rd = 0
var names = [
	"George",
	"Stephen",
	"Chuck",
	"Susan",
	"Reginold",
	"Mary-Ann",
	"Stick",
	"Horace",
	"Teddy",
	"Turgle",
]
var sticks = [
	preload("uid://6kgoi3021u2y"),
	preload("uid://bi6ath14bg6jk"),
	preload("uid://bjciq8tin4crg"),
	preload("uid://fohfgdytbcme"),
	preload("uid://bdsow8be8ueei"),
	preload("uid://b02du4l30pjro"),
	
]
var outlines = [
	preload("uid://bjfcbav2lf6s4"),
	preload("uid://n54yvhsa6em6"),
	preload("uid://0bqme6qkd4mr"),
	preload("uid://d4ebxmbjjjn3s"),
	preload("uid://dk3tqouk1pvbu"),
	preload("uid://b4jcoshxbntxo"),
	
]

func _ready() -> void:
	
	get_parent().get_parent().connect("next", readytorecieve)
	get_parent().get_parent().go.connect(got)
	var named = false
	var similar = 0
	
	while not named:
		
		var nam = randi_range(0, names.size() - 1)
		
		similar = 0
		for child in get_parent().get_children():
			var name = child.name
			
			if name == names[nam - 1]:
				similar += 1
		if similar == 0:
			self.name = names[nam - 1]
			named = true
		
	while not named:
		await get_tree().process_frame
	
			
	var stic = randi_range(0, sticks.size())
	


	$outline.texture = outlines[stic - 1]
	$outline.visible = false
	$Sprite2D.texture = sticks[stic - 1]
	$Label.text = self.name
	var shortest = INF
	var closest = Vector2.ZERO
	
	
	for p in range(checkpoints.size()):
		
		close = false
		var random_int = rng.randi_range(bottomp[p].y, topp[p].y)
		
		
		checkpoints[p].y = random_int
		
		pt = checkpoints[p]
		
		
		if distance < shortest:
			shortest = distance
			closest = checkpoints[p]
		
		target = global_position.direction_to(pt)
		
		if pt.y > global_position.y:
			
			rd = -0.5
		else:
			rd = 0.5
		dir = target
		max_speed = randi_range(5000, 8000)
		
		while close == false:
			
			await get_tree().process_frame
		
		
	var next_point = closest
	
	
	
func _process(delta: float) -> void:
	
	if floor(distance) < 10:
		close = true

		
		
	distance = pt.x - global_position.x
	
	rotation_degrees += rd
	if $outline.visible and not blinking:
		blink()
func blink():
	blinking = true
	var tween = create_tween()
	
	tween.tween_property($outline, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN)
	
	
	
	tween.tween_property($outline, "modulate:a", 0.0, 1.5).set_ease(Tween.EASE_OUT)
	await tween.finished

	blinking = false
func _physics_process(delta: float) -> void:
	if floating:
		if speed < max_speed:
			speed += accel
		else:
			speed -= accel
	
	var t = speed * delta * dir
	
	velocity = velocity.lerp(t, 1)
	
	move_and_slide()


func _on_river_body_entered(body: Node2D) -> void:
	floating = true
func got():
	floating = true
func readytorecieve():
	await get_tree().create_timer(0.1).timeout
	emit_signal("stickdata", name, $Sprite2D.texture, self)
	
