extends CharacterBody2D
class_name Enemy

const gm = preload("res://Scripts/game_manager.gd")

@export var can_be_alerted : bool
@export var alert_distance : float

@export var max_health : int
@export var damage_dealt : int

@onready var health : int = max_health
var alerted = false

func _ready():
	gm.enemy_list.append(self)
	
func _process(_delta):
	if !alerted and abs(gm.player_pos.x - global_position.x) + abs(gm.player_pos.y - global_position.y) < alert_distance:
		alert(true)
	if $Killbox.get_overlapping_areas()
		pass
	
func alert(alert_others):
	if !can_be_alerted:
		return	
	alerted = true
	if (!alert_others):
		return
	for i in gm.enemy_list.size():
		if abs(gm.enemy_list[i].global_position.x - global_position.x) + abs(gm.enemy_list[i].global_position.y - global_position.y) < alert_distance:
			pass
			#gm.enemy_list[i].get_script().alert(false)
func player_hit():
	pass
func take_damage(damage):
	health -= damage
	if health <= 0:
		on_death()
		destory()
	
func on_death():
	pass
	
func destory():
	gm.enemy_list.erase(self)
	self.queue_free()
