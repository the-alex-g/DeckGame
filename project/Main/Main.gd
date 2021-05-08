extends Node2D

# signals
signal can_move
signal cannot_move

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _map := $Map
onready var _player := $Player


func _on_Player_check_direction(from:Vector2, direction:Vector2)->void:
	var can_move:bool = _map.check_can_move(from,direction)
	if can_move:
		emit_signal("can_move")
	else:
		emit_signal("cannot_move")
