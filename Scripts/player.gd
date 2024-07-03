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

# Attack
@export var attack_time : int

# Debug
var debug_enabled = false

# Misc
var facing = "right"


var is_jumping = false
var direction : float
var y_direction : float
var attacking = false
var attack_timer = 0

func _process(_delta):
	if attack_timer > 0:
		attack_timer -= 1

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		debug_menu()
# Gravity
	direction = Input.get_axis("left","right")
	y_direction = Input.get_axis("up","down")
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
# Attack
	if attack_timer > 0:
		attacking = true
		$AttackArea/AttackHitbox.visible = true
	else:
		attacking = false
		$AttackArea/AttackHitbox.visible = false
		$AttackArea/AttackSprite.stop
	if attacking == true:
		$AttackArea/AttackHitbox.disabled = false
		$AttackArea/AttackSprite.visible = true
	else:
		$AttackArea/AttackHitbox.disabled = true
		$AttackArea/AttackSprite.visible = false
	if Input.is_action_just_pressed("attack") and attacking == false:
		attack()
	facing = get_facing()
	if get_facing() == "left":
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	accelerate()
# Friction
	apply_friction()
	if abs(velocity.x) < friction and direction == 0:
		velocity.x = 0
	move_and_slide()
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
func attack():
	$AttackArea/AttackSprite.frame = 0
	$AttackArea/AttackSprite.play("X")
	attack_timer = attack_time
	if facing == "left":
		$AttackArea/AttackSprite.flip_h = true
	if facing == "right":
		$AttackArea/AttackSprite.flip_h = false
	if Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
		$AttackArea.position.x = 0
		$AttackArea.position.y = -12.5
		if facing == "left":
			$AttackArea/AttackSprite.rotation_degrees = 90
		else:
			$AttackArea/AttackSprite.rotation_degrees = 270
	elif Input.is_action_pressed("down") and !is_on_floor() and !Input.is_action_pressed("up"):
		$AttackArea.position.x = 0
		$AttackArea.position.y = 23.5
		if facing == "right":
			$AttackArea/AttackSprite.rotation_degrees = 90
		else:
			$AttackArea/AttackSprite.rotation_degrees = 270
	elif facing == "right":
		$AttackArea.position.x = 12.5
		$AttackArea.position.y = 5.5
		$AttackArea/AttackSprite.rotation_degrees = 0
	elif facing == "left":
		$AttackArea.position.x = -12.5
		$AttackArea.position.y = 5.5
		$AttackArea/AttackSprite.rotation_degrees = 0
func get_facing() -> String:
	if Input.is_action_pressed("left"):
		return "left"
	elif Input.is_action_pressed("right"):
		return "right"
	else:
		return facing
func debug_menu():
	debug_enabled = !debug_enabled
	if debug_enabled:
		get_tree().set_debug_collisions_hint(true)
	else:
		get_tree().set_debug_collisions_hint(false)
