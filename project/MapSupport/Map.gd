class_name MapHandler
extends Node2D

# signals

# enums

# constants
const MAP_LAYOUT_PATH := 'res://MapSupport/MapLayout.tscn'
const IMPASSABLE_TILE_INDEXES := [1,]

# exported variables

# variables
var _ignore

# onready variables
onready var _tile_map := $TileMap


func _ready():
	generate_card(0)


func generate_card(card_number:int)->void:
	var map_layout:MapLayout = load(MAP_LAYOUT_PATH).instance()
	var card_tiles := map_layout.get_card_map(card_number)
	map_layout.free()
	for tile_position in card_tiles:
		var tile_index:int = card_tiles[tile_position]
		_tile_map.set_cellv(tile_position, tile_index)


func check_can_move(from:Vector2, direction:Vector2)->bool:
	var from_in_map:Vector2 = _tile_map.world_to_map(from)
	var tile_to_check := from_in_map+direction
	var tile:int = _tile_map.get_cellv(tile_to_check)
	if IMPASSABLE_TILE_INDEXES.has(tile):
		return false
	else:
		return true
