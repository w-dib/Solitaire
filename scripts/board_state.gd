# board_state.gd
extends Node2D

signal on_drawpile_empty
signal on_drawpile_full

# The card scene to be duplicated for all cards in the deck
var card_scene: PackedScene = preload("res://scenes/card.tscn")
var drawpile_z_index := 0
# Arrays to manage card locations with type annotations
var all_cards: Array[Card] = []

var foundations: Array = [
	[],  # Foundation 1
	[],  # Foundation 2
	[],  # Foundation 3
	[]   # Foundation 4
]

var tableau_piles: Array = [
	[],  # Pile 1
	[],  # Pile 2
	[],  # Pile 3
	[],  # Pile 4
	[],  # Pile 5
	[],  # Pile 6
	[]   # Pile 7
]

var draw_pile: Array[Card] = []
var stock_pile: Array[Card] = []

# Array of card texture names
var card_names: Array[String] = [
	"card_hearts_A", "card_hearts_02", "card_hearts_03", "card_hearts_04", "card_hearts_05", "card_hearts_06",
	#"card_hearts_07", "card_hearts_08", "card_hearts_09", "card_hearts_10", "card_hearts_J", "card_hearts_Q", "card_hearts_K",
	#"card_diamonds_A", "card_diamonds_02", "card_diamonds_03", "card_diamonds_04", "card_diamonds_05", "card_diamonds_06",
	#"card_diamonds_07", "card_diamonds_08", "card_diamonds_09", "card_diamonds_10", "card_diamonds_J", "card_diamonds_Q", "card_diamonds_K",
	#"card_clubs_A", "card_clubs_02", "card_clubs_03", "card_clubs_04", "card_clubs_05", "card_clubs_06", "card_clubs_07",
	#"card_clubs_08", "card_clubs_09", "card_clubs_10", "card_clubs_J", "card_clubs_Q", "card_clubs_K",
	#"card_spades_A", "card_spades_02", "card_spades_03", "card_spades_04", "card_spades_05", "card_spades_06",
	#"card_spades_07", "card_spades_08", "card_spades_09", "card_spades_10", "card_spades_J", "card_spades_Q", "card_spades_K"
]

func _ready() -> void:
	initialize_deck()

func initialize_deck() -> void:
	for texture_name in card_names:
		var card_instance: Card = card_scene.instantiate()
		# Add card_instance to the scene tree
		add_child(card_instance)
		card_instance.set_card_properties(texture_name)
		card_instance.name = texture_name
		
		all_cards.append(card_instance)
		draw_pile.append(card_instance)
		shuffle_deck(draw_pile)
		
		# Assign initial position off-screen or to a designated area
		card_instance.position = Vector2(-100, -100)  # Placeholder position
		
func shuffle_deck(deck: Array) -> void:
	deck.shuffle()

func draw_card() -> Card:
	if draw_pile.size() == 0:
		restock()
		return
	else:
		on_drawpile_full.emit()
		var drawn_card: Card = draw_pile.pop_back() as Card
		stock_pile.append(drawn_card)
		drawn_card.z_index = drawpile_z_index
		drawn_card.show_front()
		drawpile_z_index += 1
		return drawn_card
	
func restock() -> void:
	print("Before restock:")
	print("Stock pile size:", stock_pile.size())
	print("Draw pile size:", draw_pile.size())

	on_drawpile_empty.emit()
	
	draw_pile = stock_pile.duplicate()
	draw_pile.reverse()
	stock_pile.clear()
	
	for card in draw_pile:
		card.z_index = 0
		card.show_back()
		card.position = Vector2(-100, -100)

	print("After restock:")
	print("Stock pile size:", stock_pile.size())
	print("Draw pile size:", draw_pile.size())
