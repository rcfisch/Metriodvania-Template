extends Enemy

var dir : int = 1
var dir_to_player : int = 1
var dis_to_player : float

@export var speed = 50
@export var is_patrolling : bool = true

# Jump
var max_fall_speed = 880

@export_category("Jump")
@export var attack_jump_distance : float = 280
@export var jump_height : float = 160
@export var jump_seconds_to_peak : float = 0.42
@export var jump_seconds_to_descent : float = 0.5
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
		if is_on_floor() and dis_to_player < attack_jump_distance:
			if dis_to_player > attack_jump_distance - 20:
				jump()
				
			
	elif is_patrolling and is_on_floor():
		if check_for_obsticles():
			dir = dir * -1
			$Raycasts.scale.x = scale.x * -1
		move_on_patrol()
	move_and_slide()

func jump():
	if is_on_floor():
		velocity.y = jump_velocity
		
	if velocity.x > 0:
		velocity.x +=  100
	if velocity.x < 0:
		velocity.x -=  100
func move_on_patrol():
	if is_on_floor():
		velocity = Vector2(speed * dir, velocity.y)
func move_toward_player():
	if is_on_floor():
		velocity = Vector2(speed * dir_to_player, velocity.y)
	else: 
		if abs(velocity.x) < speed / 10:
			velocity.x += (speed * dir_to_player) / 10
	
func check_for_obsticles() -> bool:
	if $Raycasts/Wallcast2D.is_colliding():
		return true
	else: return false
	
func get_gravity() -> float:
# Return correct gravity for the situation
	if velocity.y < 0:
		return jump_gravity
	else: 
		return fall_gravity
