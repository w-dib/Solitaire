extends Area2D
class_name Card

signal card_clicked
signal hovered_over
signal hovered_off

@export var card_picture: Texture

@onready var sprite_2d: Sprite2D = $Sprite2D

var can_move_card := true

func _ready() -> void:
	sprite_2d.texture = card_picture
	get_parent().connect_card_signals(self)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		card_clicked.emit(self)

func _on_mouse_entered() -> void:
	hovered_over.emit(self)

func _on_mouse_exited() -> void:
	hovered_off.emit(self)
