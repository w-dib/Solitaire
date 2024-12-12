extends Area2D
class_name Card

signal card_clicked

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		card_clicked.emit(self)
