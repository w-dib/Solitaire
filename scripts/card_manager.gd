extends Node

var card_being_dragged := false 
var current_card : Card = null

func _on_card_card_clicked(card: Card) -> void:
	if not card_being_dragged:
		card_being_dragged = true
		current_card = card
	elif card_being_dragged:
		card_being_dragged = false
		current_card.position = current_card.get_global_mouse_position()

func _process(delta: float) -> void:
	if card_being_dragged && current_card:
		current_card.position = current_card.get_global_mouse_position()
