extends CharacterBody2D
class_name Enemy

const gm = preload("res://Scripts/game_manager.gd")

@export var speed = 50
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

@export var alert_distance : float
var alerted = false

func _ready():
	#print(jump_velocity)
	#print(jump_gravity)
	#print(fall_gravity)
	print(max_fall_speed)
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
			gm.enemy_list[i].get_script().alert(false)
			
func destory():
	gm.enemy_list.erase(self)
	self.queue_free()
