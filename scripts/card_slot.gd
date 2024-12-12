extends Area2D

signal card_entered
signal card_exited

func _on_area_entered(area: Area2D) -> void:
	if area is Card:
		card_entered.emit(self)

func _on_area_exited(area: Area2D) -> void:
	if area is Card:
		card_exited.emit(self)
