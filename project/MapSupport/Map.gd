class_name MapHandler
extends Node2D

# signals
signal new_player_position(new_position)

# enums

# constants
const MAP_LAYOUT_PATH := 'res://MapSupport/MapLayout.tscn'
const IMPASSABLE_TILE_INDEXES := [-1,1,]
const GATE_TILE_INDEX := 0
const EMPTY_TILES := [0]

# exported variables

# variables
var _ignore

# onready variables
onready var _base_tiles := $BaseTiles
onready var _interactable_tiles := $InteractableTiles


func generate_card(card_number:int)->void:
	_base_tiles.clear()
	_interactable_tiles.clear()
	var map_layout:MapLayout = load(MAP_LAYOUT_PATH).instance()
	add_child(map_layout)
	var card_tiles := map_layout.get_card_map(card_number)
	map_layout.queue_free()
	var base_tiles:Dictionary = card_tiles['base_tiles']
	var interactable_tiles:Dictionary = card_tiles['interactable_tiles']
	for tile_position in base_tiles:
		var tile_index:int = base_tiles[tile_position]
		_base_tiles.set_cellv(tile_position, tile_index)
	for tile_position in interactable_tiles:
		var tile_index:int = interactable_tiles[tile_position]
		_interactable_tiles.set_cellv(tile_position, tile_index)
	_get_new_player_position()


func _get_new_player_position()->void:
	var used_tiles:Array = _base_tiles.get_used_cells()
	var valid_tiles:PoolVector2Array = []
	for tile_position in used_tiles:
		var tile_index:int = _base_tiles.get_cellv(tile_position)
		if EMPTY_TILES.has(tile_index):
			valid_tiles.append(tile_position)
	var final_position_index := randi()%valid_tiles.size()
	var final_position_at_map_coords := valid_tiles[final_position_index]
	var final_position_at_world_coords:Vector2 = _base_tiles.map_to_world(final_position_at_map_coords)
	final_position_at_world_coords.x += 16
	final_position_at_world_coords.y += 11
	emit_signal("new_player_position", final_position_at_world_coords)

func check_can_move(from:Vector2, direction:Vector2)->bool:
	var from_in_map:Vector2 = _base_tiles.world_to_map(from)
	var tile_to_check := from_in_map+direction
	var tile:int = _base_tiles.get_cellv(tile_to_check)
	if IMPASSABLE_TILE_INDEXES.has(tile):
		return false
	else:
		return true


func check_interactions(at:Vector2)->void:
	var at_map_coords:Vector2 = _interactable_tiles.world_to_map(at)
	var tile_at_point:int = _interactable_tiles.get_cellv(at_map_coords)
	if tile_at_point == GATE_TILE_INDEX:
		generate_card(randi()%9)
