extends CharacterBody2D
# Acceleration and speed cap
@export var accel : float
@export var air_accel : float
@export var speed : float
@export var max_fall_speed : float
# Jump
@export var jump_height : float
@export var jump_seconds_to_peak : float
@export var jump_seconds_to_descent : float
@export var variable_jump_gravity_multiplier : float
# Jump Calculations
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_seconds_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_seconds_to_peak * jump_seconds_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_seconds_to_descent * jump_seconds_to_descent)) * -1
@onready var fastfall_gravity = fall_gravity * 1.5
# Leniency
@export var coyote_frames : float
var coyote_time : float

# Friction
@export var friction = 20
@export var air_friction : float

var is_jumping = false
var direction : float


func _physics_process(delta):
# Gravity
	direction = Input.get_axis("left","right")
	if velocity.y < max_fall_speed:
		velocity.y += get_gravity() * delta
	else: 
		velocity.y = max_fall_speed
	
	if is_on_floor() and is_jumping == false:
		coyote_time = coyote_frames
	else:
		coyote_time -= 1
	if Input.is_action_just_pressed("jump"):
		jump()
		
	if velocity.y > 0:
		is_jumping = false
		
	
	accelerate()
# Friction
	apply_friction()
	if abs(velocity.x) < friction and direction == 0:
		velocity.x = 0
	move_and_slide()
	print(direction)
func accelerate():
	if is_on_floor():
		# Right
		if direction == 1:
			velocity.x = min(velocity.x + accel, speed)
		# Left
		if direction == -1:
			velocity.x = max(velocity.x - accel, -speed)
	else:
# Air Acceleration
		# Right
		if direction == 1:
			velocity.x = min(velocity.x + air_accel, speed)
		# Left
		if direction == -1:
			velocity.x = max(velocity.x - air_accel, -speed)
func get_gravity() -> float:
# Return correct gravity for the situation
	if velocity.y < 0:
		if is_jumping == true and Input.is_action_pressed("jump"):
			return jump_gravity  
		else:
			return jump_gravity * variable_jump_gravity_multiplier
	elif Input.is_action_pressed("down"):
		return fastfall_gravity
	else: 
		return fall_gravity
func apply_friction():
# Apply friction
	if is_on_floor():
		if velocity.x > 0:
			velocity.x -= friction
		if velocity.x < 0:
			velocity.x += friction
	else:
		if velocity.x > 0:
			velocity.x -= air_friction
		if velocity.x < 0:
			velocity.x += air_friction
func jump():
	if coyote_time > 0:
		velocity.y = jump_velocity
		is_jumping = true
		coyote_time = 0
