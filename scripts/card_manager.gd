extends Node2D

@export var snapping_speed = 0.15
@export var highlight_scale := Vector2(1.1,1.1)

const COLLISION_MASK_CARD = 1

var screen_size

var is_hovering_on_card
var card_being_dragged = null 
var current_slot : CardSlot = null
var card_initial_position := Vector2.ZERO


func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y,0,screen_size.y)) 

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_at_mouse()
			if card:
				card_being_dragged = card
		else:
			card_being_dragged = false

func raycast_at_mouse():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null

func connect_card_signals(card):
	card.connect("hovered_over", on_hovered_over)
	card.connect("hovered_off", on_hovered_off)
	
func on_hovered_over(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlighted_card(card, true)

func on_hovered_off(card):
	highlighted_card(card, false)
	var new_card_hovered = raycast_at_mouse()
	if new_card_hovered:
		highlighted_card(new_card_hovered, true)
	else:	
		is_hovering_on_card = false
	
func highlighted_card(card, hovered):
	if hovered:
		card.scale = highlight_scale
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider
	print(highest_z_card)
	#for card in cards:
		#if card.z_index > highest_z_card.z_index:
			#highest_z_card = card
	
	
#func _on_card_clicked(card: Card) -> void:
	#if not card_being_dragged:
		## Start dragging
		#card_being_dragged = true
		#current_card = card
		#card_initial_position = current_card.global_position
		#current_card.z_index = 10  # Bring card to the front
#
	#elif card_being_dragged:
		## Stop dragging
		#card_being_dragged = false
#
		#if current_slot and current_slot.occupying_card == null:
			## Snap card to slot
			#var tween = get_tree().create_tween()
			#tween.tween_property(current_card, "global_position", current_slot.global_position, snapping_speed)
			#current_slot.occupying_card = current_card
			#current_card.z_index = 0  # Reset z-index
			#current_slot = null
		#else:
			## Return card to its original position
			#var tween = get_tree().create_tween()
			#tween.tween_property(current_card, "global_position", card_initial_position, snapping_speed)
			#current_card.z_index = 0  # Reset z-index
#
		#current_card = null
#
#func _on_card_slot_card_entered(slot: Area2D) -> void:
	#if slot.occupying_card == null:  # Only allow empty slots
		#current_slot = slot
#
#func _on_card_slot_card_exited(slot: Area2D) -> void:
	#if current_slot == slot:  # Only clear the slot if the current card was in it
		#current_slot = null
