extends Area2D

# Enums
enum _LASER_TYPE {
	BASIC,
	FAST,
	STRONG
}

enum _GUN_TYPE {
	SINGLE,
	DOUBLE,
	TRIPLE
}

# Player's Settings
export (float) var _move_speed: = 150.0
export (float) var _lifes     : = 3.0
export (int)   var _gun_level     : = 0

export (_LASER_TYPE) var _laser_type: = _LASER_TYPE.FAST
export (_GUN_TYPE)   var _gun_type  : = _GUN_TYPE.SINGLE

# Private Vars
var _motion: = Vector2.ZERO
var _can_shot: = true

# Nodes
onready var _basic_laser:  = preload("res://Lasers/BasicLaser.tscn")
onready var _fast_laser:   = preload("res://Lasers/FastLaser.tscn")
onready var _strong_laser: = preload("res://Lasers/StrongLaser.tscn")

onready var _center_cannon: = $CannonPos/CenterCannon
onready var _left_cannon:   = $CannonPos/LeftCannon
onready var _right_cannon:  = $CannonPos/RightCannon
onready var _laser_cd: = $LaserCd

onready var _left_cannon_spr:  = $Sprites/LeftCannon
onready var _right_cannon_spr: = $Sprites/RightCannon

# Methods
func _handle_movement(delta: float) -> void:
	var left  = int(Input.is_action_pressed('left'))
	var right = int(Input.is_action_pressed('right'))
	var up    = int(Input.is_action_pressed('up'))
	var down  = int(Input.is_action_pressed('down'))
	
	var h_move = (right - left) * _move_speed
	var v_move = (down - up) * _move_speed
	
	_motion.x = h_move * delta
	_motion.y = v_move * delta
	self.position += _motion


func _handle_shooting(delta: float) -> void:
	var shoot = int(Input.is_action_pressed('shoot'))
	
	if shoot and _can_shot:
		_can_shot = false
		
		if _gun_type == _GUN_TYPE.SINGLE:
			_cannon_fire(_center_cannon)
		elif _gun_type == _GUN_TYPE.DOUBLE:
			_cannon_fire(_left_cannon)
			_cannon_fire(_right_cannon)
		elif _gun_type == _GUN_TYPE.TRIPLE:
			_cannon_fire(_center_cannon)
			_cannon_fire(_left_cannon)
			_cannon_fire(_right_cannon)
		
		_laser_cd.start()


func _cannon_fire(cannon: Node) -> void:
	var laser = null
	
	if _laser_type == _LASER_TYPE.BASIC:
		laser = _basic_laser.instance()
	elif _laser_type == _LASER_TYPE.FAST:
		laser = _fast_laser.instance()
	elif _laser_type == _LASER_TYPE.STRONG:
		laser = _strong_laser.instance()
	
	_laser_cd.wait_time = laser._cooldown
	laser.global_position = cannon.global_position
	get_owner().add_child(laser)


func _ready() -> void:
	self.add_to_group(Groups.PLAYER_GROUP)


func _process(delta: float) -> void:
	_handle_movement(delta)
	_handle_shooting(delta)


func _on_LaserCd_timeout():
	_can_shot = true
