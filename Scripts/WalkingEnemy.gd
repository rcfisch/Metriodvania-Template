extends Enemy

var dir : int = 1
var dir_to_player : int = 1
var dis_to_player : float

@export var accel = 60
@export var speed = 200
@export var is_patrolling : bool = true

# Jump
var max_fall_speed = 880

@export_category("Jump")
@export var attack_jump_distance = 150
@export var jump_height = 160
@export var jump_seconds_to_peak = 0.42
@export var jump_seconds_to_descent = 0.5
# Jump Calculations
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_seconds_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_seconds_to_peak * jump_seconds_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_seconds_to_descent * jump_seconds_to_descent)) * -1


func _physics_process(delta):
	
	dis_to_player = abs(global_position.x - gm.player_pos.x)
	
	if velocity.y < max_fall_speed:
		velocity.y += get_gravity() * delta
	
	if velocity.x > 0:
		$Sprite.flip_h = true
		
	if velocity.x < 0:
		$Sprite.flip_h = false

	if alerted:
		dir_to_player = clamp(gm.player_pos.x - global_position.x, -1, 1) 
		$Raycasts.scale.x = dir_to_player
		move_toward_player()
		if is_on_floor() and check_for_obsticles():
			jump()
		if is_on_floor() and dis_to_player < attack_jump_distance and abs(gm.player_vel.x) < 20:
			if dis_to_player > attack_jump_distance - 20:
				jump()
	elif is_patrolling and is_on_floor():
		if check_for_obsticles():
			dir = dir * -1
			$Raycasts.scale.x = dir
		move_on_patrol()
	move_and_slide()

	print(dir)
func jump():
	if is_on_floor():
		velocity.y = jump_velocity
		velocity.x += (100 * dir_to_player)
func move_on_patrol():
	if is_on_floor():
		velocity = Vector2(speed * dir, velocity.y)
func move_toward_player():
	if is_on_floor():
		# Right
		if dir_to_player == 1:
			velocity.x = min(velocity.x + accel, speed)
		# Left
		if dir_to_player == -1:
			velocity.x = max(velocity.x - accel, -speed)
	
func check_for_obsticles() -> bool:
	if $Raycasts/Wallcast2D.is_colliding():
		return true
	elif !$Raycasts/Floorcast2D.is_colliding():
		if is_on_floor():
			return true
		else: 
			return false
	else:
		return false
	
func get_gravity() -> float:
# Return correct gravity for the situation
	if velocity.y < 0:
		return jump_gravity
	else: 
		return fall_gravity
