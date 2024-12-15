extends Area2D
class_name Card

signal card_clicked

@export var card_picture: Texture

@onready var sprite_2d: Sprite2D = $Sprite2D

var can_move_card := true

func _ready() -> void:
	sprite_2d.texture = card_picture

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		#get_viewport().set_input_as_handled()
		card_clicked.emit(self)
