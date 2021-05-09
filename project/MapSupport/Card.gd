extends Node2D

# signals
signal can_move
signal cannot_move

# enums

# constants

# exported variables
export var spawn_particle_height := 20

# variables
var _ignore

# onready variables
onready var _map := $Map
onready var _player := $Player
onready var _spawn_particles := $PlayerSpawnParticles


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
	_player.phase_in()
	_player.set_deferred('position', new_position)
	var particle_position := Vector2.ZERO
	particle_position.y = new_position.y - spawn_particle_height
	particle_position.x = new_position.x
	_spawn_particles.position = particle_position
	_spawn_particles.emitting = true
