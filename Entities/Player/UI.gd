extends Node2D

const gm = preload("res://Scripts/game_manager.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health()

func health():
	if gm.player_health == 0:
		$Health1.play("disabled")
		$Health2.play("disabled")
		$Health3.play("disabled")
		$Health4.play("disabled")
		$Health5.play("disabled")
	if gm.player_health == 1:
		$Health1.play("enabled")
		$Health2.play("disabled")
		$Health3.play("disabled")
		$Health4.play("disabled")
		$Health5.play("disabled")
	if gm.player_health == 2:
		$Health1.play("enabled")
		$Health2.play("enabled")
		$Health3.play("disabled")
		$Health4.play("disabled")
		$Health5.play("disabled")
	if gm.player_health == 3:
		$Health1.play("enabled")
		$Health2.play("enabled")
		$Health3.play("enabled")
		$Health4.play("disabled")
		$Health5.play("disabled")
	if gm.player_health == 4:
		$Health1.play("enabled")
		$Health2.play("enabled")
		$Health3.play("enabled")
		$Health4.play("enabled")
		$Health5.play("disabled")
	if gm.player_health == 5:
		$Health1.play("enabled")
		$Health2.play("enabled")
		$Health3.play("enabled")
		$Health4.play("enabled")
		$Health5.play("enabled")
