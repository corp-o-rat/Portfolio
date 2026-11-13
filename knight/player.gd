extends CharacterBody2D
@onready var inv = %inv

@onready var bodyanims = $Bodyanims
@onready var armsanims = $Armsanims

var maxspeed = 50
var speed = 0
var dir = 1
var lastdir = 1
var accel = 2
var animb = "idle"
var anima = "idle"
var newanimb = "idle"
var newanima = "idle"
var dirletter = "R"
var inuse = false
var use = ""
var facing = -1
var lastfacing = -1
func _ready():
	
	update()
func input():

	
	
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -300
		print("Boing")
	if Input.is_action_just_pressed("leftclick"):
		#if dir == 0:
			
		inuse = true
		use = "Arms/swing"
		await armsanims.animation_finished
		inuse = false
			
func _physics_process(delta):
	input()
	lastdir = dir
	lastfacing = facing
	if dir:
		speed += accel
	if speed > maxspeed: speed = maxspeed
	
		
	dir = Input.get_axis("left", "right")
	if dir > 0:
		facing = -1
	if dir < 0:
		facing = 1
	if dir:
		velocity.x = dir * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
func update():
	for appendage in get_tree().get_nodes_in_group("chain"):
		appendage.position.x *= -1
		appendage.offset.x *= -1
		lastfacing = facing
func animations():
	if facing != lastfacing:
		update()
		
	
	if dir != 0:
		
		newanimb = "walk"
		if not inuse:
			newanima = "Arms/walk"
		else:
			newanima = use
	else:
			newanimb = "idle"
			if not inuse:
				newanima = "Arms/idle"
			else:
				newanima = use
	if lastdir < 0:
		dirletter= "L"
	elif lastdir > 0:
		dirletter = "R"
	
	newanimb += dirletter
	newanima += dirletter
	if newanimb != animb:
		bodyanims.play(newanimb)
		animb = newanimb
	if newanima != anima:
		armsanims.play(newanima)
		
		anima = newanima
		
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		inv.visible = !inv.visible
	animations()


	

	


func _on_hitbox_body_entered(body):
	body.hurt(50)
