extends Area2D

enum TableauPile {TableauPile, TableauPile2, TableauPile3, TableauPile4, TableauPile5, TableauPile6, TableauPile7}
@export var pile: TableauPile

# Vertical spacing between cards
const CARD_VERTICAL_SPACING: int = 5

func _ready() -> void:
	# Connect signals for cards entering this tableau pile
	var card_nodes := get_tree().get_nodes_in_group("Card")
	for card_node: Card in card_nodes:
		card_node.entered_tableau.connect(_on_entered_tableau_pile)

func _on_entered_tableau_pile(card: Card, tableau: Area2D) -> void:
	# Only process if this tableau pile is the one receiving the card
	if tableau == self:
		var tableau_index := int(pile)
		var tableau_stack: Array = BoardState.tableau_piles[tableau_index]
		
		for existing_card in tableau_stack:
			if existing_card == card:
				print("Card already in tableau:", card.name)
				return

		if tableau_stack.size() == 0:
			add_card_to_pile(card, tableau_stack)
			_move_card_to_tableau_array(card, tableau_index)
			
		elif check_if_can_add(card, tableau_stack):
			add_card_to_pile(card, tableau_stack)
			_move_card_to_tableau_array(card, tableau_index)
			
		else:
			_reset_card_position(card)

func check_if_can_add(card: Card, tableau_stack: Array) -> bool:
	print(card.color)
	print(tableau_stack.back().color)
	if card.color != tableau_stack.back().color:
		print("different color")
		return true
	else:
		print("same color")
		return false

func add_card_to_pile(card: Card, tableau_stack: Array) -> void:
	card.global_position = global_position + Vector2(0, tableau_stack.size() * CARD_VERTICAL_SPACING)
	card.initial_position = card.global_position 
	card.valid_drop = false
	print("Card " + card.name + " added to tableau: " + self.name)

func _reset_card_position(card: Card) -> void:
	card.global_position = card.initial_position
	card.initial_position = Vector2.ZERO

func _move_card_to_tableau_array(card: Card, tableau_index: int) -> void:
	# Find the pile the card came from
	var previous_pile := BoardState.find_pile(card)
	if previous_pile != "":
		match previous_pile:
			"stock_pile":
				BoardState.stock_pile.erase(card)
			"draw_pile":
				BoardState.draw_pile.erase(card)
			"tableau_0", "tableau_1", "tableau_2", "tableau_3", "tableau_4", "tableau_5", "tableau_6":
				var other_tableau_index := previous_pile.get_slice("_", 1).to_int()
				print(str(card) + " just exited " + str(other_tableau_index))
				BoardState.tableau_piles[tableau_index].erase(card)
			"foundation_0", "foundation_1", "foundation_2", "foundation_3":
				var foundation_index := previous_pile.get_slice("_", 1).to_int()
				BoardState.foundations[foundation_index].erase(card)

	# Add the card to the tableau array
	BoardState.tableau_piles[tableau_index].append(card)	
	card.z_index = BoardState.tableau_piles[tableau_index].size()
