extends Node2D

@onready var card_manager: Node2D = $"../CardManager"
@onready var stockpile: Marker2D = $Stockpile
@onready var card_spawner: Node2D = $"../CardSpawner"

var card_stack: Array = []  # The draw pile stack of cards

func _ready() -> void:
	card_spawner.connect("spawned_cards", _initialize_stack)
	

func _on_draw_pile_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		_card_drawn()

func _card_drawn() -> void:
	if card_stack.size() > 0:
		# Get the topmost card from the stack
		var top_card = card_stack.pop_back()
		
		# Move the card to the stockpile position
		top_card.position = stockpile.position
		
		# Flip the card to show its face
		top_card.face_up.show()
	else:
		print("No more cards to draw!")  # Handle empty stack

func _initialize_stack() -> void:
	# Populate the card stack using the children of CardManager
	for i in range(card_manager.get_child_count() - 1, -1, -1):
		var card: Card = card_manager.get_child(i) as Card
		if card:
			print(card)
			card_stack.append(card)  # Add all cards to the stack
