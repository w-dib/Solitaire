extends Node

@export var snapping_speed = 0.15

var card_being_dragged := false 
var card_in_slot := false
var current_card : Card = null
var current_slot : Area2D = null
var card_initial_position := Vector2.ZERO

func _on_card_card_clicked(card: Card) -> void:
	if not card_being_dragged:
		card_being_dragged = true
		current_card = card
		card_initial_position = current_card.global_position  # Ensure we save the position
	elif card_being_dragged:
		# Stop dragging
		card_being_dragged = false

		# If the card is over a slot, snap to it
		if card_in_slot and current_slot:
			current_card.global_position = current_slot.global_position
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(current_card, "global_position", card_initial_position, snapping_speed)
			#current_card.global_position = card_initial_position

		# Clear the current card reference to prevent issues
		current_card = null

func _process(delta: float) -> void:
	if card_being_dragged && current_card:
		current_card.global_position = current_card.get_global_mouse_position()

func _on_card_slot_card_entered(slot: Area2D) -> void:
	current_slot = slot
	card_in_slot = true

func _on_card_slot_card_exited(slot: Area2D) -> void:
	card_in_slot = false
