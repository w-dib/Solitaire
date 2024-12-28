#extends Area2D
#
#class_name CardSlot
#
#signal card_entered
#signal card_exited
#
#var occupying_card: Card = null
#
#func _on_area_entered(card: Card) -> void:
	#if occupying_card != card:
			#card_entered.emit(self)
#
#func _on_area_exited(card: Card) -> void:
	#card_exited.emit(self)
	#if occupying_card == card:
		#occupying_card = null
