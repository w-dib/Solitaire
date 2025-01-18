extends Area2D

signal on_drawpile_empty
signal on_drawpile_full

@onready var stockpile: Marker2D = %Stockpile
@onready var pile_full: Sprite2D = %PileFull
@onready var pile_empty: Sprite2D = %PileEmpty

func _ready() -> void:
	on_drawpile_empty.connect(_on_drawpile_empty)
	on_drawpile_full.connect(_on_drawpile_full)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		var drawn_card: Card = draw_card()
		if drawn_card:
			drawn_card.position = stockpile.global_position
			
func draw_card() -> Card:
	if BoardState.draw_pile.size() == 0:
		restock()
		return
	else:
		on_drawpile_full.emit()
		var drawn_card: Card = BoardState.draw_pile.pop_back() as Card
		BoardState.stock_pile.append(drawn_card)
		drawn_card.z_index = BoardState.drawpile_z_index
		drawn_card.show_front()
		BoardState.drawpile_z_index += 1
		return drawn_card
	
func restock() -> void:
	on_drawpile_empty.emit()
	
	BoardState.draw_pile = BoardState.stock_pile.duplicate()
	BoardState.draw_pile.reverse()
	BoardState.stock_pile.clear()
	
	for card in BoardState.draw_pile:
		card.z_index = 0
		card.show_back()
		card.position = Vector2(-100, -100)

func _on_drawpile_empty() -> void:
	pile_empty.show()
	pile_full.hide()

func _on_drawpile_full() -> void:
	pile_empty.hide()
	pile_full.show()
