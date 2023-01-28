extends Camera2D

const NOISE_SHAKE_SPEED: = 30.0
const NOISE_SHAKE_STRENGTH: = 60.0
const SHAKE_DECAY_RATE: = 5.0

onready var _noise = OpenSimplexNoise.new()

var _noise_i: = 0.0
var _shake_strength: = 0.0

func _ready() -> void:
	randomize()
	_noise.seed = randi()
	_noise.period = 2

func _apply_shake() -> void:
	_shake_strength = NOISE_SHAKE_STRENGTH

func _process(delta: float) -> void:
	_shake_strength = lerp(_shake_strength, 0, SHAKE_DECAY_RATE * delta)
	self.offset = _get_noise_offset(delta)

func _get_noise_offset(delta: float) -> Vector2:
	_noise_i += delta * NOISE_SHAKE_SPEED
	return Vector2(
		_noise.get_noise_2d(1, _noise_i) * _shake_strength,
		_noise.get_noise_2d(100, _noise_i) * _shake_strength
	)
