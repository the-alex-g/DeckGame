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
var _fading := false

# onready variables
onready var _move_tween := $MoveTween
onready var _fade_tween := $FadeTween
onready var _sprite := $Sprite


func _process(_delta:float)->void:
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
		if _direction.x > 0:
			_sprite.flip_h = false
		elif _direction.x < 0:
			_sprite.flip_h = true


func _on_Tween_tween_all_completed()->void:
	active = true
	emit_signal("finished_moving", position)


func _on_Card_can_move():
	var new_position := cell_size*_direction
	new_position += position
	_move_tween.interpolate_property(self, 'position', null, new_position, move_time)
	_move_tween.start()


func _on_Card_cannot_move():
	active = true


func phase_in()->void:
	_fade_tween.interpolate_property(self, 'modulate',Color(1,1,1,0), Color(1,1,1,1), 1.0)
	_fade_tween.start()
