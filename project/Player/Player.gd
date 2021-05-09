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
var _alpha := 1.0
var _fading := false
var _fade_value := 0.0

# onready variables
onready var _tween := $Tween


func _process(delta:float)->void:
	if not active and not _fading:
		return
	if active:
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
	if _fading:
		_fade_value += delta
		_alpha = lerp(0, 1, _fade_value)
		if _fade_value >= 1:
			_alpha = 1
			_fade_value = 0
			_fading = false


func _on_Tween_tween_all_completed()->void:
	active = true
	emit_signal("finished_moving", position)


func _on_Card_can_move():
	var new_position := cell_size*_direction
	new_position += position
	_tween.interpolate_property(self, 'position', null, new_position, move_time)
	_tween.start()


func _on_Card_cannot_move():
	active = true


func phase_in()->void:
	_fading = true
