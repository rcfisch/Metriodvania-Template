extends Enemy

@export var speed : float = 10
@export var gravity : float = 1
@export var is_patrolling : bool = true

var dir : int = 1
var dir_to_player : int = 1

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += 1
	if alerted:
		pass
	elif is_on_floor() and is_patrolling:
		if check_for_obsticles():
			dir = dir * -1
			scale = scale * -1
		move_on_patrol()	

func move_on_patrol():
	velocity = Vector2(speed * dir, velocity.y)
func move_toward_player():
	velocity = Vector2(speed * dir_to_player, velocity.y)
	
func check_for_obsticles() -> bool:
	if is_on_wall():
		return true
	return !$RayCast2D.is_colliding()
