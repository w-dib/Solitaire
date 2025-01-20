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
		
		# Check the foundation index against board_state.gd
		var foundation_index := suit
		var foundation_stack: Array = BoardState.foundations[foundation_index]
		
		# Skip processing if the card is already in the foundation
		if card in foundation_stack:
			print("Card already in foundation:", card.name)
			return
		
		if card.suit != suit:
			print("Card suit does not match foundation suit.")
			_reset_card_position(card)
			return
			
		# Check if the card's rank is valid for this foundation
		if foundation_stack.size() == 0:
			# Only ace should be allowed here.
			if card.rank != card.CardRank.A:
				print("Only ace allowed in an empty foundation slot.")
				_reset_card_position(card)
				return
			
		else:
			# Get the top card in the foundation
			var top_card: Card = foundation_stack.back()
			if card.rank != top_card.rank + 1:
				_reset_card_position(card)
				return
		
		# WARNING WARNING WARNING WARNING 
		# BELOW CODE BLOCK IS BROKEN
		# WARNING WARNING WARNING WARNING 
		
		# Update foundation array and remove card from previous pile
		_move_card_to_foundation_array(card, foundation_index)

		# Snap the card to the foundation
		card.global_position = global_position
		card.initial_position = card.global_position
		card.valid_drop = false
		print("Card added to foundation:", card.name)

func _reset_card_position(card: Card) -> void:
	card.global_position = card.initial_position
	card.initial_position = Vector2.ZERO

func _move_card_to_foundation_array(card: Card, foundation_index: int) -> void:
	# Find the pile the card came from
	var previous_pile := BoardState.find_pile(card)
	if previous_pile != "":
		match previous_pile:
			"stock_pile":
				BoardState.stock_pile.erase(card)
			"draw_pile":
				BoardState.draw_pile.erase(card)
			"tableau_0", "tableau_1", "tableau_2", "tableau_3", "tableau_4", "tableau_5", "tableau_6":
				var tableau_index := previous_pile.get_slice("_", 1).to_int()
				BoardState.tableau_piles[tableau_index].erase(card)
			"foundation_0", "foundation_1", "foundation_2", "foundation_3":
				var other_foundation_index := previous_pile.get_slice("_", 1).to_int()
				BoardState.foundations[other_foundation_index].erase(card)

	# Add the card to the foundation array
	BoardState.foundations[foundation_index].append(card)	
	card.z_index = BoardState.foundations[foundation_index].size()
