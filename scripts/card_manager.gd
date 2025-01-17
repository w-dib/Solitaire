extends Node2D

@onready var screen_size := get_viewport_rect().size

const CARD_COLLISION := 1

var card_being_dragged: Card = null
var is_hovering_on_pile := false
var current_pile: Area2D
		
func _process(_delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	if card_being_dragged:
		var clamped_position := Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)
		card_being_dragged.position = clamped_position

func _input(event: InputEvent) -> void:
	var initial_position := Vector2.ZERO
	if event.is_action_pressed("Click"):
			var card := _raycast_at_card()
			if card:
				card_being_dragged = card
				initial_position = card.position
			else:
				card_being_dragged = null
				initial_position = Vector2.ZERO
	elif event.is_action_released("Click") and card_being_dragged:
		if is_hovering_on_pile:
			card_being_dragged.position = current_pile.global_position
		else:
			card_being_dragged.position = initial_position
		card_being_dragged = null

func _raycast_at_card() -> Card:
	var space_state := get_world_2d().direct_space_state
	var parameters := PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_COLLISION

	var result := space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider
	return null

#func _get_card_with_highest_z_index(result: Array) -> Card:
	#var highest_z_index := -1
	#for card: Dictionary in result:
		#if card.collider.z_index > highest_z_index:
			#highest_z_index = card.collider.z_index
		#return card.collider
	#return null

func _on_hovered_over(area: Area2D, card: Card) -> void:
	if area is PileRoot:
		current_pile = area
		is_hovering_on_pile = true

func _on_hovered_off(area: Area2D, card: Card) -> void:
	if area is PileRoot:
		current_pile = null
		is_hovering_on_pile = false
