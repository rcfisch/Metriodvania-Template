extends Camera2D

@export var random_strength : float = 30
@export var shake_fade : float = 5

var rng = RandomNumberGenerator.new()

var shake_strength : float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply_shake():
	shake_strength  = random_strength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		apply_shake()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
	offset = random_offset()
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
