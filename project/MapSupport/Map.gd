class_name MapHandler
extends Node2D

# signals
signal new_player_position(new_position)

# enums

# constants
const MAP_LAYOUT_PATH := 'res://MapSupport/MapLayout.tscn'
const IMPASSABLE_TILE_INDEXES := [-1,1,6,7,8,12]
const GATE_TILE_INDEX := 0
const EMPTY_TILES := [0,3,4,5,9]
const MAP_EMPTY := 0
const MAP_FULL := 1
const A := {'empty':[3,4,5], 'solid':[6,7]}
const B := {'empty':[9,10.11], 'solid':[8,12]}
const C := {'empty':[0], 'solid':[1]}
const D := {'empty':[0], 'solid':[1]}
const E := {'empty':[0], 'solid':[1]}
const F := {'empty':[0], 'solid':[1]}
const G := {'empty':[0], 'solid':[1]}
const H := {'empty':[0], 'solid':[1]}
const I := {'empty':[0], 'solid':[1]}

# exported variables

# variables
var _ignore
var _layout_and_tiles := {1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[]}
var _tile_set_list := ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']

# onready variables
onready var _base_tiles := $BaseTiles
onready var _interactable_tiles := $InteractableTiles


func _ready()->void:
	for layout in 9:
		layout += 1
		for tiles in layout:
			var tiles_as_string:String = _tile_set_list[tiles]
			_layout_and_tiles[layout].append(tiles_as_string)


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
	# get the specific tiles to use for the card
	var searching := true
	var tile_set_finder:Array
	while searching:
		tile_set_finder = _layout_and_tiles[card_number+1]
		if tile_set_finder.size() > 0:
			searching = false
	var tile_set_index := randi()%tile_set_finder.size()
	var tile_set_name:String = tile_set_finder[tile_set_index]
	_layout_and_tiles[card_number+1].erase(tile_set_name)
	var tile_set:Dictionary = get(tile_set_name)
	var empty_tiles:Array = tile_set['empty']
	var full_tiles:Array = tile_set['solid']
	# replace the 'blank' tiles with the new ones
	for tile_position in _base_tiles.get_used_cells():
		var tile_index:int = _base_tiles.get_cellv(tile_position)
		if tile_index == MAP_EMPTY:
			var replacement_tile_index := randi()%empty_tiles.size()
			var replacement_tile:int = empty_tiles[replacement_tile_index]
			_base_tiles.set_cellv(tile_position, replacement_tile)
		elif tile_index == MAP_FULL:
			var replacement_tile_index := randi()%full_tiles.size()
			var replacement_tile:int = full_tiles[replacement_tile_index]
			_base_tiles.set_cellv(tile_position, replacement_tile)
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
