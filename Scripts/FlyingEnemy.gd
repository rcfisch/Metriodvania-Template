extends Enemy

@export var speed : float = 1

@export var path_points : Array[Node2D]
var path_point_index : int = 0

func _physics_process(delta):
	if alerted:
		move_towards_point(gm.player_pos, delta)
	else:
		if abs(path_points[path_point_index].global_position.x - global_position.x) + abs(path_points[path_point_index].global_position.y - global_position.y) < 0.1:
			if path_point_index == path_points.size() - 1:
				path_point_index = 0
			else:
				path_point_index += 1
		move_towards_point(path_points[path_point_index].global_position, delta)
	move_and_slide()
		
func move_towards_point(position, delta):
	velocity = abs(global_position - position).normalized() * speed
