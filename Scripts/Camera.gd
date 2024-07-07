extends Camera2D
class_name mCamera

static var instance : mCamera
var rng = RandomNumberGenerator.new()

static var shake_fade : float
static var shake_strength : int

func _ready():
	instance = self

static func apply_shake(strength : int = 5, fade : float = 3):
	shake_strength = strength
	shake_fade = fade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
	offset = random_offset()
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
