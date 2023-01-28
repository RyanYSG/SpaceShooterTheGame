extends Area2D

# Laser's Settings
export (float) var _move_speed: = 350.0
export (float) var _damage: = 1.0
export (float) var _cooldown: = .35
export (bool)  var _enemy: = false
export (Color) var _explosion_color = Color(1, 1, 1)

# Private Vars
var _motion: = Vector2.ZERO

# Nodes
onready var _explosion: = preload('res://Explosion/LaserExplosion.tscn')


func _ready() -> void:
	if _enemy:
		add_to_group(Groups.ENEMY_LASER_GROUP)
	else:
		add_to_group(Groups.PLAYER_LASER_GROUP)


# Methods
func _process(delta: float) -> void:
	if _enemy:
		_motion.y = 1 * _move_speed
	else:
		_motion.y = -1 * _move_speed
	
	if self.position.y > System.SCREEN_HEIGHT + 50:
		self.queue_free()
	
	self.position += _motion * delta


func _on_Laser_area_entered(area):
	if area.is_in_group(Groups.ENEMY_GROUP):
		area._take_damage(_damage)
		var e = _explosion.instance()
		e.modulate = _explosion_color
		e.playing = true
		e.global_position = self.global_position
		get_parent().add_child(e)
		queue_free()
