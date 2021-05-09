class_name Player
extends Node2D

# signals
signal check_direction(from, direction)
signal finished_moving(at)

# enums

# constants

# exported variables
export var move_time := 1

# variables
var _ignore
var active := true
var _direction := Vector2.ZERO
var cell_size := Vector2(32,22)

# onready variables
onready var _tween := $Tween


func _process(_delta:float)->void:
	if not active:
		return
	else:
		_direction = Vector2.ZERO
		if Input.is_action_just_pressed("left"):
			_direction.x -= 1
		elif Input.is_action_just_pressed("right"):
			_direction.x += 1
		elif Input.is_action_just_pressed("up"):
			_direction.y -= 1
		elif Input.is_action_just_pressed("down"):
			_direction.y += 1
		if _direction != Vector2.ZERO:
			active = false
			emit_signal('check_direction', position, _direction)


func _draw():
	draw_circle(Vector2.ZERO, 10, Color.black)


func _on_Main_can_move()->void:
	var new_position := cell_size*_direction
	new_position += position
	_tween.interpolate_property(self, 'position', null, new_position, move_time)
	_tween.start()


func _on_Main_cannot_move()->void:
	active = true


func _on_Tween_tween_all_completed()->void:
	active = true
	emit_signal("finished_moving", position)
