extends Area2D
class_name Card

signal hovered_over
signal hovered_off

@export var texture: Texture

@onready var face_up: Sprite2D = $face_up
@onready var face_down: Sprite2D = $face_down

func _ready() -> void:
	face_up.hide()
	face_up.texture = texture

func _on_area_entered(area) -> void:
	hovered_over.emit(area, self)

func _on_area_exited(area):
	hovered_off.emit(area, self)

#func _on_mouse_entered() -> void:
	#hovered_over.emit(self)
#
#func _on_mouse_exited() -> void:
	#hovered_off.emit(self)
