extends Area2D

var is_selected = false
var position_on_grid = Vector2i.ZERO
var is_hovered = false
var just_moved = false
enum Piece_type {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}
enum Piece_colour {WHITE = 0, BLACK = -1}
var piece_type 
var colour
const TILE_SIZE = 16
@onready var le_sprite: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

signal piece_selected(Area2D)

@onready var tilemap: TileMap = get_parent().get_node("TileMap")



		

#function to check if mouse is hovering around piece
func _on_mouse_entered() -> void:
	is_hovered = true
	print("one")

#func for when mouse is not hovering around piece
func _on_mouse_exited() -> void:
	is_hovered = false
	print("zero")
	
# setter to set selected to false
func _unselect() -> void:
	is_selected = false
	
#setter to set selected to trye
func _select() -> void:
	is_selected = true
	
#getter for piece_tupe
func _get_piece_type() -> int:
	return piece_type
	
#setter for piece_type
func _set_piece_type(type: int):
	piece_type = type

#getter for piece colour
func get_colour()->int:
	return colour

#setter for piece colour
func set_colour(color: int):
	colour = color
	
#setter for intial position
func intial_pos_setter(pos: Vector2i) -> void:
	position_on_grid = pos
	
	
#function to handle input handling for mouse clicks
func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if just_moved:
		just_moved = false
		return
	if is_hovered and event is InputEventMouseButton:
		if not is_selected: 
			var mouse_event := event as InputEventMouseButton
			if mouse_event.button_index== MOUSE_BUTTON_LEFT and mouse_event.pressed:
				is_selected = true
				emit_signal("piece_selected", self)
				print("pawn selected at tile: ", position_on_grid)
	

#abstract try_to_move function for abstracted piece
