extends Meteor

# Spawn
onready var _small: = preload('res://Meteors/SmallMeteor.tscn')


# Override
func _destroy() -> void:
	var m1 = _small.instance()
	var m2 = _small.instance()
	
	m1.global_position = self.position + Vector2(-15, 0)
	m2.global_position = self.position + Vector2(15, 0)
	
	get_parent().add_child(m1)
	get_parent().add_child(m2)
	
	var e = _explosion.instance()
	e.playing = true
	e.global_position = self.global_position
	get_parent().add_child(e)
	
	emit_signal('_destroyed')
	queue_free()
