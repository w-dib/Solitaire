extends Node

@export var snapping_speed = 0.15

var card_being_dragged := false 
var current_card : Card = null
var current_slot : CardSlot = null
var card_initial_position := Vector2.ZERO

func _on_card_clicked(card: Card) -> void:
	if not card_being_dragged:
		# Start dragging
		card_being_dragged = true
		current_card = card
		card_initial_position = current_card.global_position
		current_card.z_index = 10  # Bring card to the front
		print("Started dragging card: ", current_card.name)

	elif card_being_dragged:
		# Stop dragging
		card_being_dragged = false

		if current_slot and current_slot.occupying_card == null:
			# Snap card to slot
			print("Snapping card ", current_card.name, " to slot ", current_slot.name)
			var tween = get_tree().create_tween()
			tween.tween_property(current_card, "global_position", current_slot.global_position, snapping_speed)
			current_slot.occupying_card = current_card
			current_card.z_index = 0  # Reset z-index
			current_slot = null
		else:
			# Return card to its original position
			print("Returning card ", current_card.name, " to original position")
			var tween = get_tree().create_tween()
			tween.tween_property(current_card, "global_position", card_initial_position, snapping_speed)
			current_card.z_index = 0  # Reset z-index

		current_card = null
		print("Stopped dragging")

func _process(delta: float) -> void:
	if card_being_dragged and current_card:
		current_card.global_position = current_card.get_global_mouse_position()
		#print("Dragging card: ", current_card.name, " at position: ", current_card.global_position)

func _on_card_slot_card_entered(slot: Area2D) -> void:
	if slot.occupying_card == null:  # Only allow empty slots
		current_slot = slot
		print("Hovering over slot: ", slot.name)
	else:
		print("Hovering over slot: ", slot.name, "occupied by ", slot.occupying_card)

func _on_card_slot_card_exited(slot: Area2D) -> void:
	if current_slot == slot:  # Only clear the slot if the current card was in it
		print("Left slot: ", slot.name)
		current_slot = null
