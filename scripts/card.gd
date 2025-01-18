# card.gd
extends Area2D

class_name Card

# Enums for Suit, Color, and Rank
enum CardColor { RED, BLACK }
enum CardSuit { HEARTS, DIAMONDS, SPADES, CLUBS }
enum CardRank {
	A = 1,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	TEN,
	J,
	Q,
	K
}

# Variables for card properties
var suit: CardSuit
var color: CardColor
var rank: CardRank

# Variables for card movement
var click_position := Vector2.ZERO
var initial_position := Vector2.ZERO
var is_dragging := false

# References to Sprite2D nodes
@onready var face_down: Sprite2D = %face_down
@onready var face_up: Sprite2D = %face_up

#Get screen dimensions to clamp cards within screen
@onready var screen_size := get_viewport_rect().size

# Texture paths
var front_texture_path: String
var back_texture_path: String = "res://assets/images/kenney-playing-cards-pack/card_back.png"

func _ready() -> void:
	# Initialize the card to show back
	show_back()

func _process(_delta: float) -> void:
	if is_dragging:
		# Get the mouse's current global position
		var mouse_pos := get_global_mouse_position()
		
		# Calculate the new global position of the card
		var new_position := mouse_pos - click_position
		
		# Clamp the new position to be within the screen bounds
		new_position.x = clamp(new_position.x, 0, screen_size.x)
		new_position.y = clamp(new_position.y, 0, screen_size.y)
		
		# Apply the clamped position
		global_position = new_position

func show_front() -> void:
	face_up.visible = true
	face_down.visible = false

func show_back() -> void:
	face_up.visible = false
	face_down.visible = true
	
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		pick_up_card(event)
	
	if event.is_action_released("Click"):
		drop_card(event)

func _input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		is_dragging = false

func pick_up_card(event: InputEvent) -> void:
	initial_position = global_position
	var objects_clicked := mouse_raycast(event, 0b1)
	var colliders := objects_clicked.map(
		func(dict: Dictionary):
			return dict.collider
	)
	
	colliders.sort_custom(
		func(collider_1, collider_2):
			return collider_1.z_index < collider_2.z_index
	)
	if colliders[-1] == self:
		is_dragging = true
		click_position = get_local_mouse_position()

func drop_card(event: InputEvent) -> void:
	var object := mouse_raycast(event, 0b110) #layers 2 & 3 in bitmask.
	# Assume no valid drop by default
	var valid_drop := false
	
	# Check if there are any results from the raycast
	if object.size() > 0:
		var first_dict = object[0]  # Get the first dictionary
		if "collider" in first_dict:
			var collider = first_dict["collider"]  # Safely access the collider
			if collider.is_in_group("Foundation"):
				valid_drop = true
				# Perform the valid drop logic here
	
	if not valid_drop:
		global_position = initial_position
		initial_position = Vector2.ZERO

func mouse_raycast(event: InputEvent, layer: int) -> Array[Dictionary]:
	var parameters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	parameters.position = event.position
	parameters.collide_with_areas = true
	# Set the collision layer mask to detect relevant layers
	parameters.collision_mask = layer
	var objects_clicked := get_world_2d().direct_space_state.intersect_point(parameters)
	return objects_clicked

func set_card_properties(texture_name: String) -> void:
	# Parse texture_name to set suit, color, and rank using begins_with
	if texture_name.begins_with("card_hearts_"):
		suit = CardSuit.HEARTS
		color = CardColor.RED
	elif texture_name.begins_with("card_diamonds_"):
		suit = CardSuit.DIAMONDS
		color = CardColor.RED
	elif texture_name.begins_with("card_spades_"):
		suit = CardSuit.SPADES
		color = CardColor.BLACK
	elif texture_name.begins_with("card_clubs_"):
		suit = CardSuit.CLUBS
		color = CardColor.BLACK
	else:
		push_error("Unknown card texture: %s" % texture_name)
		return
	
	# Extract rank from texture_name
	var rank_str: String = texture_name.get_slice("_", 2)
	rank = parse_rank(rank_str)
	
	if rank == 100:
		push_error("Invalid rank extracted from texture name: %s" % texture_name)
		return
	
	# Load the front texture directly
	var texture_path: String = "res://assets/images/kenney-playing-cards-pack/%s.png" % texture_name
	var front_texture: Texture = load(texture_path)
	if front_texture:
		face_up.texture = front_texture
	else:
		push_error("Failed to load front texture: %s" % texture_path)

func parse_rank(rank_str: String) -> int:
	match rank_str.to_upper():
		"A":
			return CardRank.A
		"02", "2":
			return CardRank.TWO
		"03", "3":
			return CardRank.THREE
		"04", "4":
			return CardRank.FOUR
		"05", "5":
			return CardRank.FIVE
		"06", "6":
			return CardRank.SIX
		"07", "7":
			return CardRank.SEVEN
		"08", "8":
			return CardRank.EIGHT
		"09", "9":
			return CardRank.NINE
		"10":
			return CardRank.TEN
		"J":
			return CardRank.J
		"Q":
			return CardRank.Q
		"K":
			return CardRank.K
		_:
			return 100 # Error value
