extends Enemy

@export var speed : float = 1

@export var path_points : Array[Node2D]
var path_point_index : int = 0

func _physics_process(delta):
	if alerted:
		move_towards_point(gm.player_pos, delta)
	else:
		if abs(path_points[path_point_index].global_position - global_position) < 0.1:
			path_point_index += 1
		move_towards_point(gm.player_pos, delta)
		
func move_towards_point(position, delta):
	velocity += abs(path_points[path_point_index].global_position - global_position).normalized() * (speed * delta)
