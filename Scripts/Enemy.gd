extends CharacterBody2D
class_name Enemy

const gm = preload("res://Scripts/game_manager.gd")

@export var can_be_alerted : bool
@export var alert_distance : float

@export var max_health : int = 5
@export var damage_dealt : int = 1

@onready var health : int = max_health
var alerted = false

func _ready():
	gm.enemy_list.append(self)
	
func _physics_process(delta):
	if !alerted and abs(gm.player_pos.x - global_position.x) + abs(gm.player_pos.y - global_position.y) < alert_distance:
		alert(true)
	if $Killbox.has_overlapping_areas():
		for i in $Killbox.get_overlapping_areas():
			hit_player()
	
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
func hit_player():
	print("hit player")
	Player.hurt(global_position, velocity, damage_dealt)
func take_damage(damage):
	health -= damage
	if health <= 0:
		on_death()
		destroy()
	
func on_death():
	pass
	
func destroy():
	gm.enemy_list.erase(self)
	self.queue_free()
