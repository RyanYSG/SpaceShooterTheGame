extends Area2D
class_name Meteor

# Meteor's Settings
export (float) var _move_speed: = 100.0
export (float) var _lifes: = 3.0

# Meteor's Signals
signal _destroyed

# Private Vars
var _motion: = Vector2.ZERO

# Nodes
onready var _explosion = preload('res://Explosion/Explosion.tscn')
onready var _ship_part = preload('res://Collectables/ShipPart.tscn')


# Methods
func _take_damage(amount: float) -> void:
	if amount > _lifes:
		_destroy()
	else:
		_lifes -= amount
	

func _destroy() -> void:
	var e = _explosion.instance()
	e.playing = true
	e.global_position = self.global_position
	get_parent().add_child(e)
	emit_signal('_destroyed')
	
	var amount = rand_range(0, 3)
	
	while amount > 0:
		var part = _ship_part.instance()
		part.global_position = self.global_position + Vector2(10, 0)
		get_parent().add_child(part)
		amount = amount - 1
	
	queue_free()

func _ready() -> void:
	randomize()
	add_to_group(Groups.ENEMY_GROUP)
	self.rotation_degrees = randi() % 360
	_motion.y = 1 * _move_speed
	_motion.x = rand_range(-1, 1) * _move_speed


func _process(delta: float) -> void:
	self.position += _motion * delta
	
	if _lifes <= 0:
		_destroy()

	if self.position.y > System.SCREEN_HEIGHT + 50:
		queue_free()
	
	if self.position.x < -50:
		self.position.x = System.SCREEN_WIDTH + 50
	elif self.position.x > System.SCREEN_HEIGHT + 50:
		self.position.x = -50
