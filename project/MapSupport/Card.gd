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


func _ready():
	randomize()
	var card_index := randi()%9
	_map.generate_card(card_index)


func _on_Player_check_direction(from:Vector2, direction:Vector2)->void:
	var can_move:bool = _map.check_can_move(from,direction)
	if can_move:
		emit_signal("can_move")
	else:
		emit_signal("cannot_move")


func _on_Player_finished_moving(at:Vector2)->void:
	_map.check_interactions(at)


func _on_Map_new_player_position(new_position:Vector2)->void:
	_player.set_deferred('position', new_position)
