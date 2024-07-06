extends CharacterBody2D
# Acceleration and speed cap
@export_category("Speeds")
@export var accel : float
@export var air_accel : float
@export var speed : float
@export var max_fall_speed : float
# Jump
@export_category("Jump")
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
@export_category("Friction")
@export var friction = 20
@export var air_friction : float
@export var recoil_friction : float

# Attack
@export_category("Attack")
@export var attack_time : int
@export var attack_recoil : float
@export var pogo_velocity : float

@export var enemy_knockback : float
var attack_direction = "right"
var recoiled = false

# Player Damage
@export var invicibility_frames : int
var inv_timer = 0
# Debug
var debug_enabled = false

# Misc
var facing = "right"


var is_jumping = false
var direction : float
var y_direction : float
var attacking = false
var attack_timer = 0

const gm = preload("res://Scripts/game_manager.gd")

func _process(_delta):
	if inv_timer > 0:
		inv_timer -= 1
	if attack_timer > 0:
		attack_timer -= 1
	if attack_timer < 20 - attack_time:
		recoiled = false

func _physics_process(delta):
	gm.player_pos = global_position
	gm.fall_speed = max_fall_speed
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
	if attack_timer > 20 - attack_time:
		attacking = true
	else:
		attacking = false
	if attack_timer > 0:
		$AttackArea/AttackSprite.visible = true
	else:
		$AttackArea/AttackSprite.visible = false
	if attacking == true:
		$AttackArea/AttackHitbox.visible = true
		$AttackArea/AttackHitbox.disabled = false
	else:
		$AttackArea/AttackHitbox.disabled = true
		$AttackArea/AttackHitbox.visible = false
	if attack_timer == 0:
		if Input.is_action_just_pressed("attack") and attacking == false:
			attack()
	if $AttackArea.has_overlapping_bodies():
		apply_attack_recoil()
# Facing and sprite flipping
	facing = get_facing()
	if get_facing() == "left":
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	accelerate()
# Friction
	apply_friction()
	if abs(velocity.x) < friction and direction == 0 and !attacking:
		velocity.x = 0
	move_and_slide()
	
# Hurt Player
	if $Hurtbox.has_overlapping_areas():
		for i in $Hurtbox.get_overlapping_areas():
			if inv_timer == 0:
				hurt(i.global_position)
			
		
# Print
	#print(get_gravity())
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
		if is_jumping == true and Input.is_action_pressed("jump") and attack_timer == 0:
			return jump_gravity
		else:
			return jump_gravity * variable_jump_gravity_multiplier
	else: 
		return fall_gravity
func apply_friction():
# Apply friction
	if is_on_floor() and direction == 0 and attack_timer == 0:
		if velocity.x > 0:
			velocity.x -= friction
		if velocity.x < 0:
			velocity.x += friction
	elif direction == 0 and !is_on_floor():
		if velocity.x > 0:
			velocity.x -= air_friction
		if velocity.x < 0:
			velocity.x += air_friction
	elif attack_timer > 0 and is_on_floor() and direction == 0:
		if velocity.x > 0:
			velocity.x -= recoil_friction
		if velocity.x < 0:
			velocity.x += recoil_friction
func jump():
	if coyote_time > 0:
		velocity.y = jump_velocity
		is_jumping = true
		coyote_time = 0
func attack():
	$AttackArea/AttackSprite.position.x = 10
	$AttackArea/AttackSprite.frame = 0
	$AttackArea/AttackSprite.play("X")
	attack_timer = 20
	if Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
		attack_direction = "up"
		$AttackArea.position.x = 0
		$AttackArea.position.y = -7
		$AttackArea.rotation_degrees = 270
	elif Input.is_action_pressed("down") and !is_on_floor() and !Input.is_action_pressed("up"):
		attack_direction = "down"
		$AttackArea.position.x = 0
		$AttackArea.position.y = 17
		$AttackArea.rotation_degrees = 90
	elif facing == "right":
		attack_direction = "right"
		$AttackArea.position.x = 8
		$AttackArea.position.y = 5
		$AttackArea.rotation_degrees = 0
	elif facing == "left":
		attack_direction = "left"
		$AttackArea/AttackSprite.position.y = 0
		$AttackArea/AttackSprite.position.x = 5
		$AttackArea.position.x = -8
		$AttackArea.position.y = 5
		$AttackArea.rotation_degrees = 180
func apply_attack_recoil():
	if attack_direction == "up":
		velocity.y += attack_recoil
	if attack_direction == "down":
		if recoiled == false:
			velocity.y = -pogo_velocity
			recoiled = true
	if attack_direction == "left":
		velocity.x += attack_recoil
	if attack_direction == "right":
		velocity.x -= attack_recoil
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
func hurt(enemy_pos):
	var knockback = enemy_pos.direction_to(global_position) * enemy_knockback
	
	velocity = Vector2(knockback.x, -abs(knockback.y))
	inv_timer = invicibility_frames
	#print(knockback_dir * enemy_knockback)
