class_name MapLayout
extends Node2D

# signals

# enums

# constants

# exported variables
export var card_size := Vector2(6,4)

# variables
var _ignore

# onready variables
onready var _base_tiles := $BaseTiles
onready var _interactable_tiles := $InteractableTiles


func get_card_map(card_number:int)->Dictionary:
	var starting_position := card_size.x*card_number
	var master_tiles := {}
	var base_tiles := {}
	var interactable_tiles := {}
	for row in card_size.y:
		for column in card_size.x:
			column += starting_position
			var tile:int = _base_tiles.get_cell(column,row)
			if tile != -1:
				var tile_position := Vector2.ZERO
				tile_position.x = column - starting_position
				tile_position.y = row
				base_tiles[tile_position] = tile
			tile = _interactable_tiles.get_cell(column,row)
			if tile != -1:
				var tile_position := Vector2.ZERO
				tile_position.x = column - starting_position
				tile_position.y = row
				interactable_tiles[tile_position] = tile
	master_tiles['base_tiles'] = base_tiles
	master_tiles['interactable_tiles'] = interactable_tiles
	return master_tiles
