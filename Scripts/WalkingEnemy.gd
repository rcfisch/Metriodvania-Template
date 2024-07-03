extends Enemy

@export var speed : float = 10
@export var gravity : float = 1
@export var is_patrolling : bool = true

var dir : int = 1
var dir_to_player : int = 1

func _physics_process(delta):
	if velocity.x > 0:
		$Sprite.flip_h = true
	if velocity.x < 0:
		$Sprite.flip_h = false
	
	if !is_on_floor():
		velocity.y += 1
		
	if alerted:
		dir_to_player = clamp(gm.player_pos.x - global_position.x, -1, 1) 
		if !check_for_obsticles():
			move_toward_player()
			
	elif is_on_floor() and is_patrolling:
		if check_for_obsticles():
			dir = dir * -1
			scale.x = scale.x * -1
		move_on_patrol()	
	move_and_slide()

func move_on_patrol():
	velocity = Vector2(speed * dir, velocity.y)
func move_toward_player():
	velocity = Vector2(speed * dir_to_player, velocity.y)
	
func check_for_obsticles() -> bool:
	if $RayCast2D2.is_colliding():
		return false
	return !$RayCast2D.is_colliding()
