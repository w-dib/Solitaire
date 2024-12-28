extends Node2D

@onready var card_manager: Node2D = $"../CardManager"
@onready var stockpile: Marker2D = $Stockpile
@onready var draw_pile: Area2D = $DrawPile
@onready var card_spawner: Node2D = $"../CardSpawner"
@onready var empty: Sprite2D = $DrawPile/Empty
@onready var full: Sprite2D = $DrawPile/Full

var card_stack: Array = []  # The draw pile stack of cards

func _ready() -> void:
	card_spawner.connect("spawned_cards", _initialize_stack)

func _on_draw_pile_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		_draw_card()

func _draw_card() -> void:
	if card_stack.size() == 0:
		_reset_stack()
	elif card_stack.size() > 0:
		if card_stack.size() == 1:
			full.hide()
			empty.show()
		var top_card: Card = card_stack.pop_back()
		top_card.position = stockpile.position
		top_card.face_up.show()
		
func _initialize_stack() -> void:
	# Populate the card stack using the children of CardManager
	card_stack.clear()
	for i in range(card_manager.get_child_count() - 1, -1, -1):
		var card: Card = card_manager.get_child(i) as Card
		if card:
			card_stack.append(card)  # Add all cards to the stack
	empty.hide()
	full.show()
	
func _reset_stack() -> void:
		# Populate the card stack using the children of CardManager
	for i in range(card_manager.get_child_count() - 1, -1, -1):
		var card: Card = card_manager.get_child(i) as Card
		if card and card.position == stockpile.position:
			card.face_up.hide()
			card.face_down.show()
			card_stack.append(card)  # Add all cards to the stack
			card.position = Vector2(-100, -100)
	empty.hide()
	full.show()
