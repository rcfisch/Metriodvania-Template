extends CharacterBody2D
class_name Enemy

@export var alert_distance : float
var alerted = false

const gm = preload("res://Scripts/game_manager.gd")

func _ready():
	gm.enemy_list.append(self)
	
func _physics_process(delta):
	if abs(gm.player_pos - global_position) < alert_distance:
		alert()
	
func alert(alert_others = true):
	alerted = true
	if (!alert_others):
		return
	for i in gm.enemy_list.size():
		if abs(gm.enemy_list[i].global_position - global_position) < alert_distance:
			gm.enemy_list[i].get_script().alert(false)
			
func destory():
	gm.enemy_list.erase(self)
	self.queue_free()
