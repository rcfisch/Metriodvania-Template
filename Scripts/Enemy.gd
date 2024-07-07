extends CharacterBody2D
class_name Enemy

const gm = preload("res://Scripts/game_manager.gd")

@export var alert_distance : float
var alerted = false

func _ready():
	gm.enemy_list.append(self)
	
func _process(_delta):
	if !alerted and abs(gm.player_pos.x - global_position.x) + abs(gm.player_pos.y - global_position.y) < alert_distance:
		alert(true)
	
func alert(alert_others):
	alerted = true
	print("Enemy Alerted")
	if (!alert_others):
		return
	for i in gm.enemy_list.size():
		if abs(gm.enemy_list[i].global_position.x - global_position.x) + abs(gm.enemy_list[i].global_position.y - global_position.y) < alert_distance:
			pass
			#gm.enemy_list[i].get_script().alert(false)
			
func destory():
	gm.enemy_list.erase(self)
	self.queue_free()
