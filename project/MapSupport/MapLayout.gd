class_name MapLayout
extends TileMap

# signals

# enums

# constants

# exported variables
export var card_size := Vector2.ZERO

# variables
var _ignore

# onready variables


func get_card_map(card_number:int)->Dictionary:
	var starting_position := card_size.x*card_number
	var tiles := {}
	for row in card_size.y:
		for column in card_size.x:
			column += starting_position
			var tile := get_cell(column,row)
			var tile_position := Vector2.ZERO
			tile_position.x = column - starting_position
			tile_position.y = row
			tiles[tile_position] = tile
	return tiles
