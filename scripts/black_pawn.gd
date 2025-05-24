extends Area2D

var is_selected = false
@export var position_on_grid = Vector2i.ZERO
var is_hovered = false
var just_moved = false
enum Piece_type {PAWN = 0, ROOK = 1, KNIGHT = 2, BISHOP = 3, QUEEN = 4, KING = 5}
enum Piece_colour {WHITE = 0, BLACK = -1}
var piece_type 
var colour
const TILE_SIZE = 16
@onready var le_sprite: Sprite2D = $Area2D/Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D2

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
	
func get_pos()->Vector2i:
	return position_on_grid

func get_collider() -> CollisionShape2D:
	return collider
	
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
				print("black pawn selected at tile: ", position_on_grid)

func _ready() -> void:
	_set_piece_type(Piece_type.PAWN)
	set_colour(Piece_colour.BLACK)

func try_move_to(target_tile: Vector2i, tile_pos: Vector2)-> bool:
	var dx = target_tile.x - position_on_grid.x
	var dy = target_tile.y - position_on_grid.y
	var direction = -1 if colour == Piece_colour.BLACK else 1
	if is_selected :
		if dx == 0 and dy == direction:
			just_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("Moved black pawn to ", position_on_grid, " (world position: ", global_position, ")")
			return true
		elif (dy == -2 and dx == 0 and position_on_grid.y == 6):
			just_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("Moved Black pawn to ", position_on_grid, " (world position: ", global_position, ")" )
			return true
	print("Invalid move")
	return false
		
		
#case when pawn needs to move diagnolly and take over piece
func try_pawn_take_over(target_tile: Vector2i, tile_pos: Vector2) -> bool:
	var dx = abs(target_tile.x - position_on_grid.x)
	var dy = target_tile.y - position_on_grid.y
	if is_selected and dx == 1 and dy == -1:
		just_moved = true
		position_on_grid = target_tile
		global_position = tile_pos
		print("Black pawn takes over piece at ", position_on_grid)
		return true
	else:
		print("Invalid move")
		return false
#todo:
#tidy up code
#implement moving diagnolly during takeovers 
#implement hashmap for tile tracking
#implement en passant
		

	
