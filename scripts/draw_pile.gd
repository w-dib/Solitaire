extends Area2D

@onready var stockpile: Marker2D = %Stockpile

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		var drawn_card = BoardState.draw_card()
		drawn_card.position = stockpile.global_position
