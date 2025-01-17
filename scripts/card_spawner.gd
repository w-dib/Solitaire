extends Node2D

signal spawned_cards

@onready var card_folder_path := "res://assets/images/kenney-playing-cards-pack/"
@onready var card_manager: Node2D = $"../CardManager"
@onready var stock_manager: Node2D = $"../StockManager"

var card_names := [
	"card_hearts_A", "card_hearts_02", "card_hearts_03", "card_hearts_04", "card_hearts_05", "card_hearts_06",
	"card_hearts_07", "card_hearts_08", "card_hearts_09", "card_hearts_10", "card_hearts_J", "card_hearts_Q", "card_hearts_K",
	"card_diamonds_A", "card_diamonds_02", "card_diamonds_03", "card_diamonds_04", "card_diamonds_05", "card_diamonds_06",
	"card_diamonds_07", "card_diamonds_08", "card_diamonds_09", "card_diamonds_10", "card_diamonds_J", "card_diamonds_Q", "card_diamonds_K",
	"card_clubs_A", "card_clubs_02", "card_clubs_03", "card_clubs_04", "card_clubs_05", "card_clubs_06", "card_clubs_07",
	"card_clubs_08", "card_clubs_09", "card_clubs_10", "card_clubs_J", "card_clubs_Q", "card_clubs_K",
	"card_spades_A", "card_spades_02", "card_spades_03", "card_spades_04", "card_spades_05", "card_spades_06",
	"card_spades_07", "card_spades_08", "card_spades_09", "card_spades_10", "card_spades_J", "card_spades_Q", "card_spades_K"
]

func _ready() -> void:
	spawn_cards()

func spawn_cards() -> void:
	card_names.shuffle()
	for card_name: String in card_names:
		var card := preload("res://scenes/card.tscn").instantiate()
		card.texture = load(card_folder_path + card_name + ".png")
		card.name = card_name
		connect_card_signals(card)
		card_manager.add_child(card)
		card.position = Vector2(-100, -100)
	spawned_cards.emit()

func connect_card_signals(card: Card) -> void:
	card.connect("hovered_over", card_manager._on_hovered_over)
	card.connect("hovered_off", card_manager._on_hovered_off)
