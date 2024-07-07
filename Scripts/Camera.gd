extends Camera2D
class_name mCamera

static var instance : mCamera
var shake_fade : float
var rng = RandomNumberGenerator.new()

var shake_strength : float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self

static func apply_shake(strength = 5, fade = 3):
	instance.shake_strength = strength
	instance.shake_fade = fade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		apply_shake(30)
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
	offset = random_offset()
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
