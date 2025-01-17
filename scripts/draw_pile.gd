extends Area2D

@onready var stockpile: Marker2D = %Stockpile
@onready var pile_full: Sprite2D = %PileFull
@onready var pile_empty: Sprite2D = %PileEmpty


func _ready() -> void:
	BoardState.on_drawpile_empty.connect(_on_drawpile_empty)
	BoardState.on_drawpile_full.connect(_on_drawpile_full)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		var drawn_card: Card = BoardState.draw_card()
		if drawn_card:
			drawn_card.position = stockpile.global_position

func _on_drawpile_empty() -> void:
	pile_empty.show()
	pile_full.hide()

func _on_drawpile_full() -> void:
	pile_empty.hide()
	pile_full.show()
