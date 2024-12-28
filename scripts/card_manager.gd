extends Node2D

@onready var screen_size := get_viewport_rect().size

const CARD_COLLISION := 1

var card_being_dragged: Card = null
var is_hovering_on_other_card := false
		
func _process(_delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	if card_being_dragged:
		var clamped_position := Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)
		card_being_dragged.position = clamped_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
			var card := _raycast_at_card()
			if card:
				card_being_dragged = card
			else:
				card_being_dragged = null
	elif event.is_action_released("Click") and card_being_dragged:
		var mouse_pos := get_global_mouse_position()
		var clamped_position := Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)
		card_being_dragged.position = Vector2(
			mouse_pos.x if mouse_pos.x >= 0 and mouse_pos.x <= screen_size.x else clamped_position.x,
			mouse_pos.y if mouse_pos.y >= 0 and mouse_pos.y <= screen_size.y else clamped_position.y
		)

		card_being_dragged = null
	
func _on_hovered_over(card: Card) -> void:
	is_hovering_on_other_card = true
	if card_being_dragged && is_hovering_on_other_card:
		card.z_index = 0
	else:
		card.z_index = 50

func _on_hovered_off(card: Card) -> void:
	is_hovering_on_other_card = false
	card.z_index = 0

func _raycast_at_card() -> Card:
	var space_state := get_world_2d().direct_space_state
	var parameters := PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_COLLISION
	var result := space_state.intersect_point(parameters)
	if result.size() > 0:
		return _get_card_with_highest_z_index(result)
	return null

func _get_card_with_highest_z_index(result: Array) -> Card:
	var highest_z_index := -1
	for card: Dictionary in result:
		if card.collider.z_index > highest_z_index:
			highest_z_index = card.collider.z_index
		return card.collider
	return null
