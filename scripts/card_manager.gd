extends Node2D

@onready var screen_size := get_viewport_rect().size


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
		var card := _raycast_at_mouse(1)
		if card:
			card_being_dragged = card
			print("clicked")
		else:
			card_being_dragged = null
	elif event.is_action_released("Click") and card_being_dragged:
		var mouse_pos := get_global_mouse_position()
		#card_being_dragged.position = mouse_pos
		var clamped_position := Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)
		card_being_dragged.position = Vector2(
			mouse_pos.x if mouse_pos.x >= 0 and mouse_pos.x <= screen_size.x else clamped_position.x,
			mouse_pos.y if mouse_pos.y >= 0 and mouse_pos.y <= screen_size.y else clamped_position.y
		)

		card_being_dragged = null  # Reset dragging state
	
func _on_hovered_over(card: Card) -> void:
	print("Hovering over ", card.name)
	is_hovering_on_other_card = true
	if card_being_dragged && is_hovering_on_other_card:
		card.z_index = 0
	else:
		card.z_index = 50

func _on_hovered_off(card: Card) -> void:
	is_hovering_on_other_card = false
	card.z_index = 0

func _raycast_at_mouse(collision_mask: int) -> Card:
	var space_state := get_world_2d().direct_space_state
	var parameters := PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = collision_mask
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

#@export var snapping_speed = 0.15
#@export var highlight_scale := Vector2(1.1,1.1)
#
#var screen_size
#
#var is_hovering_on_card
#var card_being_dragged = null 
#
#func _ready() -> void:
	#screen_size = get_viewport_rect().size
	#
	#
#func _process(delta: float) -> void:
	#if card_being_dragged:
		#var mouse_pos = get_global_mouse_position()
		#card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y,0,screen_size.y)) 
#
#func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#var card = raycast_at_mouse()
			#if card:
				#card_being_dragged = card
		#else:
			#card_being_dragged = false
#
##func raycast_at_mouse():
	##var space_state = get_world_2d().direct_space_state
	##var parameters = PhysicsPointQueryParameters2D.new()
	##parameters.position = get_global_mouse_position()
	##parameters.collide_with_areas = true
	##parameters.collision_mask = COLLISION_MASK_CARD
	##var result = space_state.intersect_point(parameters)
	##if result.size() > 0:
		##return get_card_with_highest_z_index(result)
	##return null
#
#func connect_card_signals(card):
	#card.connect("hovered_over", on_hovered_over)
	#card.connect("hovered_off", on_hovered_off)
	#
#func on_hovered_over(card):
	#if !is_hovering_on_card:
		#is_hovering_on_card = true
		#highlighted_card(card, true)
#
#func on_hovered_off(card):
	#highlighted_card(card, false)
	#var new_card_hovered = raycast_at_mouse()
	#if new_card_hovered:
		#highlighted_card(new_card_hovered, true)
	#else:	
		#is_hovering_on_card = false
	#
#func highlighted_card(card, hovered):
	#if hovered:
		#card.scale = highlight_scale
		#card.z_index = 2
	#else:
		#card.scale = Vector2(1, 1)
		#card.z_index = 1
#
#func get_card_with_highest_z_index(cards):
	#var highest_z_card = cards[0].collider
	#print(highest_z_card)
	##for card in cards:
		##if card.z_index > highest_z_card.z_index:
			##highest_z_card = card
	#
	#
##func _on_card_clicked(card: Card) -> void:
	##if not card_being_dragged:
		### Start dragging
		##card_being_dragged = true
		##current_card = card
		##card_initial_position = current_card.global_position
		##current_card.z_index = 10  # Bring card to the front
##
	##elif card_being_dragged:
		### Stop dragging
		##card_being_dragged = false
##
		##if current_slot and current_slot.occupying_card == null:
			### Snap card to slot
			##var tween = get_tree().create_tween()
			##tween.tween_property(current_card, "global_position", current_slot.global_position, snapping_speed)
			##current_slot.occupying_card = current_card
			##current_card.z_index = 0  # Reset z-index
			##current_slot = null
		##else:
			### Return card to its original position
			##var tween = get_tree().create_tween()
			##tween.tween_property(current_card, "global_position", card_initial_position, snapping_speed)
			##current_card.z_index = 0  # Reset z-index
##
		##current_card = null
##
##func _on_card_slot_card_entered(slot: Area2D) -> void:
	##if slot.occupying_card == null:  # Only allow empty slots
		##current_slot = slot
##
##func _on_card_slot_card_exited(slot: Area2D) -> void:
	##if current_slot == slot:  # Only clear the slot if the current card was in it
		##current_slot = null


#@export_flags_2d_physics var layers_2d_physics
