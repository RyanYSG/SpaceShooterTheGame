extends Area2D

# Private Vars
var _motion: = Vector2.ZERO
var _seek_player: = true

# Nodes
onready var _float_timer: = $FloatTimer

func _handle_movement(delta: float) -> void:
	if _seek_player:
		var pos = get_parent().get_parent().get_node('SpaceShip').global_position
		
		self.global_position = lerp(self.global_position, pos, 0.03)


func _process(delta: float) -> void:
	_handle_movement(delta)


func _on_ShipPart_area_entered(area):
	if area.is_in_group(Groups.PLAYER_GROUP):
		self.queue_free()
