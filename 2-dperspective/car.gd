extends CharacterBody2D


@onready var player = $"../Player"

var drift_time := 0.0
@export var drift_decay_min := 0.2 
@export var drift_decay_max := 1.2   
@export var drift_speed_threshold := 120.0 
@export var drifting := false



@export var max_speed_forward = 100
@export var steering_angle = 15  
@export var engine_power = 100 
@export var friction = -20 
@export var friction_base = -20
@export var friction_drift = -40
@export var drag = -0.06  
@export var reversing = -50 
@export var max_speed_reverse = 40  
@export var slip_speed = 60 
@export var traction_fast = 0 
@export var traction_slow = 40 
@export var braking = -25
@onready var last_pos = global_position
var wheel_base = 8 
var acceleration = Vector2.ZERO
var steer_direction 
var last_rlspd = 0
var steering_lagspd: float = 0
var is_braking = false
var traction = traction_slow
var new_heading
var turn = 0
var old_heading = Vector2.ZERO
var clear = false
@export var is_active = true
signal traction_change(traction)
signal drift(drifting)
var deg = 0
var building = false
var target_rot_disp = 0
func _physics_process(delta: float) -> void:
	if drifting:
		%Smoke.emitting = true
		drift.emit(true)
	else:
		%Smoke.emitting = false
		drift.emit(false)
		
		clear = false
	traction_change.emit(traction)
	steering_angle = clamp(20 - velocity.length() / 6, 2, 20)
	
	var realspeed = (global_position - last_pos).length() / delta
	last_pos = global_position
	
	if last_rlspd - realspeed > 20 and get_slide_collision_count() > 0:

		collision(last_rlspd, realspeed)
		
	last_rlspd = realspeed
	if is_active:
		
		acceleration = Vector2.ZERO
		get_input(delta)
		calculate_steering(delta) 
	
		
	#if is_on_wall():
	#	velocity = -(acceleration * delta)
	#else:
	apply_friction(delta) 
	
	velocity += acceleration * delta 
	
	
	move_and_slide()  
	if is_on_wall():
		var col = get_last_slide_collision()
		if col:
			var normal = col.get_normal()
			var into_wall = velocity.dot(-normal)
			
			
			if into_wall > 0:
				velocity -= -normal * into_wall * 0.8
			
	
				
				


func get_input(delta):
	
	var tturn = Input.get_axis("left", "right")
	turn = move_toward(turn, tturn, 0.1)
	steer_direction = turn * deg_to_rad(steering_angle)
	
		
	if is_braking:
		
		if floor(velocity.length()) != 0.0:
			var d = new_heading.dot(velocity.normalized())
			acceleration = transform.x * braking * d
			
		else:
			acceleration = Vector2.ZERO
	else:
	
		if Input.is_action_pressed("up") and not Input.is_action_pressed("down"):
			building = false
			
			if velocity.length() > max_speed_forward:
				acceleration = Vector2.ZERO
			else:
				acceleration = transform.x * engine_power
				
			
	
		if Input.is_action_pressed("down") and not Input.is_action_pressed("up"):
			acceleration = transform.x * reversing
			building = false
		if Input.is_action_pressed("down") and Input.is_action_pressed("up"):
			
				
			
			if floor(velocity.length()) != 0.0:
				
				var d = new_heading.dot(velocity.normalized())
				acceleration = transform.x * braking * d
				
			else:
				
				building = true
				var weight = 1
				target_rot_disp += tturn * steering_angle / 10
				
				deg = move_toward(deg, target_rot_disp, weight)
				
				var change = Vector2.from_angle(deg_to_rad(deg))
				
				new_heading += change
				var front_lock = transform.x * 0
				drifting = true
				traction = move_toward(traction, traction_fast, 2)
				var sideways = transform.x.rotated(sign(turn) * deg_to_rad(90))
				velocity = sideways * 80
				rotation += turn * 4 * delta

func apply_friction(delta):

	if acceleration == Vector2.ZERO and velocity.length() < 5:
		velocity = Vector2.ZERO

	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	
	
	acceleration += drag_force + friction_force

	

func calculate_steering(delta):

	drift_time = drift_decay()
	drift_time = max(drift_time - delta, 0)
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0

	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta

	if is_on_wall() and acceleration.length():
		var collision = get_last_slide_collision().get_normal()
		new_heading = rear_wheel.direction_to(front_wheel + collision/8)
			
	
	else:
		
		new_heading = rear_wheel.direction_to(front_wheel)
		#print(rad_to_deg(new_heading.angle()))
	#print(new_heading)

	if old_heading == new_heading:
		
		drifting = false
		traction = move_toward(traction, traction_slow, 4)
		friction = move_toward(friction, friction_base, 4)
		
		
	
	if Input.is_action_pressed("handbrake"):
		is_braking = true
	
		if velocity.length() > slip_speed:
			drifting = true
			traction = move_toward(traction, traction_fast, 2)
			friction = move_toward(friction, friction_drift, 2)
			
			steering_lagspd = 0.1
			
		else:
			if drift_time > 0.2 and drifting:
				
				traction = move_toward(traction, traction_fast, 2)
				friction = move_toward(friction, friction_drift, 2)
				
				steering_lagspd = 0.1
			else:
				drifting = false
				traction = move_toward(traction, traction_slow, 1)
				friction = move_toward(friction, friction_base, 1)
				steering_lagspd = 0
				
	else:
		
		if drift_time > 0.6 and drifting:
			traction = move_toward(traction, traction_fast, 2)
			friction = move_toward(friction, friction_drift, 2)
			
			steering_lagspd = 0.1
		else:
			drifting = false
			traction = move_toward(traction, traction_slow, 1)
			friction = move_toward(friction, friction_base, 1)
			steering_lagspd = 0
			
		is_braking = false
		

	var d = new_heading.dot(velocity.normalized())


	if d > 0:
		
		
		
		old_heading = old_heading.slerp(new_heading, steering_lagspd)
	
		velocity = lerp(velocity, old_heading * velocity.length(), traction * delta)
		old_heading = new_heading

	if d < 0 and traction == traction_slow:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
		

	rotation = new_heading.angle()
func collision(last_rlspd, realspeed):
	
	%Crash.emitting = true
	velocity -= velocity * 1.3
	var change = last_rlspd - realspeed
	var damage = floor(change * 0.5)
	var critical = false
	damaged(damage, self, critical)
	
	
func drift_decay():
	var spd = velocity.length()
	return lerp(drift_decay_min, drift_decay_max, clamp(spd / drift_speed_threshold, 0.0, 1.0))
	
func damaged(damage, origin, is_critical):
	
	DamageNumbers.display_number(damage, origin.global_position, is_critical)
