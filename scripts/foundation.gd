extends Area2D

enum Suit {HEARTS, DIAMONDS, SPADES, CLUBS}
@export var suit: Suit

#HEARTS, DIAMONDS, SPADES, CLUBS = 0, 1, 2, 3

func _ready() -> void:
	var card_nodes := get_tree().get_nodes_in_group("Card")
	for card_node: Card in card_nodes:
		card_node.entered_foundation.connect(_on_entered_foundation)
		
func _on_entered_foundation(card: Card, foundation: Area2D) -> void:
	if foundation == self:
		print(card.suit)
