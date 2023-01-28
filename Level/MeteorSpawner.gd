extends Node2D

# Meteors
onready var _small = preload('res://Meteors/SmallMeteor.tscn')
onready var _big   = preload('res://Meteors/BigMeteor.tscn')

# Nodes
onready var _cd = $SpawnCd
onready var _cam = get_owner().get_node("Camera2D")


func _on_SpawnCd_timeout():
	var meteor = null
	var spawn_pos = Vector2(rand_range(0, System.SCREEN_WIDTH - 32), -50)
	var type = randi() % 2
	
	if type == 0:
		meteor = _small.instance()
	elif type == 1:
		meteor = _big.instance()
		meteor.connect('_destroyed', self, '_on_destroyed')
	
	meteor.global_position = spawn_pos
	add_child(meteor)

func _on_destroyed() -> void:
	_cam._apply_shake()
