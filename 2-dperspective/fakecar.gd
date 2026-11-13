extends CharacterBody2D


#@onready var player = $"../Player"

var drift_time := 0.0
@export var drift_decay_min := 0.2   # drift persistence at low speed
@export var drift_decay_max := 1.2   # drift persistence at high speed
@export var drift_speed_threshold := 120.0  # speed where drift is strongest
@export var drifting := false



@export var max_speed_forward = 50
@export var steering_angle = 15  # Maximum angle for steering the car's wheels
@export var engine_power = 50  # How much force the engine can apply for acceleration
@export var friction = -20  # The friction coefficient that slows down the car
@export var friction_base = -20
@export var friction_drift = -40
@export var drag = -0.06  # Air drag coefficient that also slows down the car
@export var reversing = -50  # Braking power when the brake input is applied
@export var max_speed_reverse = 40  # Maximum speed limit in reverse
@export var slip_speed = 60  # Speed above which the car's traction decreases (for drifting)
@export var traction_fast = 0  # Traction factor when the car is moving fast (affects control)
@export var traction_slow = 40  # Traction factor when the car is moving slow (affects control)l)
@export var braking = -25
@onready var last_pos = global_position
var wheel_base = 8  # Distance between the front and back axle of the car
var acceleration = Vector2.ZERO  # Current acceleration vector
var steer_direction = 0  # Current direction of steering
var last_rlspd = 0
var steering_lagspd: float = 0
var is_braking = false
var traction = traction_slow
var new_heading
var turn = 0

var clear = false
@export var is_active = true
signal traction_change(traction)
signal drift(drifting)
var deg = 0

var target_rot_disp = 0
func _ready() -> void:
	pass
	
	
func left(body):
	
	print(body)
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
		make_input(delta)  # Take input from player
		calculate_steering(delta)  # Apply turning logic based on steering
	
		
	#if is_on_wall():
	#	velocity = -(acceleration * delta)
	#else:
	apply_friction(delta)  # Apply friction forces to the car
	
	velocity += acceleration * delta  # Apply the resulting acceleration to the velocity
	
	
	move_and_slide()  # Move the car and handle collisions
	if is_on_wall():
		var col = get_last_slide_collision()
		if col:
			var normal = col.get_normal()
			var into_wall = velocity.dot(-normal)
			
			
			if into_wall > 0:
				velocity -= -normal * into_wall * 0.8
			
	
				
				

#function to handle input from the user and apply effects to the car's movement
func make_input(delta):
	var destination = Vector2(0,0)
	# Get steering input and translate it to an angle
	var target_dir = global_position.direction_to(destination)
	var angle_to_target = transform.x.angle_to(target_dir)
	var dead_zone = deg_to_rad(3)  # tweak this
	var target_steer
	if abs(angle_to_target) < dead_zone:
		target_steer = 0
	else:
		target_steer = clamp(angle_to_target, -deg_to_rad(steering_angle), deg_to_rad(steering_angle))
	steer_direction = move_toward(steer_direction, target_steer, 0.1)
	
	
	if position.distance_to(destination) > -20 and position.distance_to(destination) < 20:
		
		if floor(velocity.length()) != 0.0:
			var d = new_heading.dot(velocity.normalized())
			acceleration = transform.x * braking * d
			
		else:
			acceleration = Vector2.ZERO
	else:
	# If accelerate is pressed, apply engine power to the car's forward direction
		if transform.x.direction_to(destination).length() > 0:
			
			
			if velocity.length() > max_speed_forward:
				acceleration = Vector2.ZERO
			else:
				acceleration = transform.x * engine_power
				
			
		# If brake is pressed, apply braking force
		if transform.x.direction_to(destination).length() < 0:
			acceleration = transform.x * reversing
			
		
					
	
#Function to apply friction forces to the car, making it 'slide' to a halt
func apply_friction(delta):
	# If there is no input and speed is very low, just stop to prevent endless sliding
	if acceleration == Vector2.ZERO and velocity.length() < 5:
		velocity = Vector2.ZERO
	# Calculate friction force and air drag based on current velocity, and apply it
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	
	
	acceleration += drag_force + friction_force

	
# Function to calculate the steering effect
func calculate_steering(delta):
	# Calculate the positions of the rear and front wheel
	
	
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# Advance the wheels' positions based on the current velocity, applying rotation to the front wheel
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# Calculate the new heading based on the wheels' positions
	if is_on_wall() and acceleration.length():
		var collision = get_last_slide_collision().get_normal()
		new_heading = rear_wheel.direction_to(front_wheel + collision/8)
			
	
	else:
		
		new_heading = rear_wheel.direction_to(front_wheel)
		#print(rad_to_deg(new_heading.angle()))
	#print(new_heading)
	# Choose the traction model based on the current speed
	
		
		
	
	
		is_braking = false
		
	# Dot product represents how aligned the new heading is with the current velocity direction
	var d = new_heading.dot(velocity.normalized())

	# If not braking (d > 0), adjust the car velocity smoothly towards the new heading
	if d > 0:
		
		
		
		
	
		velocity = lerp(velocity, new_heading * velocity.length(), traction_slow * delta)
		
	# If braking (d < 0), reverse the direction and limit the speed
	if d < 0 and traction == traction_slow:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
		
	# Update the car's rotation to face in the direction of the new headingw
	rotation = new_heading.angle()
func collision(last_rlspd, realspeed):
	
	%Crash.emitting = true
	velocity -= velocity * 1.3
	var change = last_rlspd - realspeed
	var damage = floor(change * 0.5)
	var critical = false
	damaged(damage, self, critical)
	
	

	
func damaged(damage, origin, is_critical):
	
	DamageNumbers.display_number(damage, origin.global_position, is_critical)
