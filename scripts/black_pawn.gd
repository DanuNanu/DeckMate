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
@onready var collider: CollisionShape2D = $CollisionShape2D2
@onready var board: Node2D = get_parent()
signal piece_selected(Area2D)
@onready var highlight_map:= get_parent().get_node("Highlight")
@onready var tilemap: TileMap = get_parent().get_node("TileMap")
@onready var sprite:= $Sprite2D2


		

#function to check if mouse is hovering around piece
func _on_mouse_entered() -> void:
	is_hovered = true
	print("one")

#func for when mouse is not hovering around piece
func _on_mouse_exited() -> void:
	is_hovered = false
	print("zero")
	
# setter to set selected to false
#clear everytime unselected
func _unselect() -> void:
	highlight_map.clear()
	sprite.modulate = Color(1,1,1)
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
	if board.input_lock:
		return
	if just_moved:
		just_moved = false
		return
	if is_hovered and event is InputEventMouseButton:
		if not is_selected: 
			var mouse_event := event as InputEventMouseButton
			if mouse_event.button_index== MOUSE_BUTTON_LEFT and mouse_event.pressed:
				is_selected = true
				sprite.modulate = Color(1,1,0)
				var legal_moves = get_moves()
				highlight_map.show_light(legal_moves)
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
			sprite.modulate = Color(1,1,1)
			highlight_map.clear()
			return true
		elif (dy == -2 and dx == 0 and position_on_grid.y == 6 and is_cleared(target_tile, position_on_grid)):
			just_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("Moved Black pawn to ", position_on_grid, " (world position: ", global_position, ")" )
			sprite.modulate = Color(1,1,1)
			highlight_map.clear()
			return true
	print("Invalid move")
	sprite.modulate = Color(1,1,1)
	highlight_map.clear()
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
		sprite.modulate = Color(1,1,1)
		highlight_map.clear()
		return true
	else:
		print("Invalid move")
		sprite.modulate = Color(1,1,1)
		highlight_map.clear()
		return false
		
		
func promotion(target_tile: Vector2i, tile_pos:Vector2, index: int) -> Area2D:
	if position_on_grid.y == 0:
		var piece_unloaded
		var text
		match index:
			0: 
				piece_unloaded = preload("res://scenes/black_queen.tscn")	
				text= "Black Queen"
			1: 
				piece_unloaded = preload("res://scenes/black_rook.tscn")
				text = "Black Rook"
			2: 
				piece_unloaded = preload("res://scenes/black_knight.tscn")
				text = "Black Knight"
			3: 
				piece_unloaded = preload("res://scenes/black_bishop.tscn")
				text = "Black Bishop"
			
			_: print("error with path: couldn't load scene")
		var piece = piece_unloaded.instantiate()
		board.add_child(piece)
		piece.global_position = tile_pos
		piece.intial_pos_setter(target_tile)
		piece.just_moved = true
		piece.input_pickable = true
		piece.connect("mouse_entered", Callable(piece, "_on_mouse_entered"))
		piece.connect("mouse_exited", Callable(piece,"_on_mouse_exited"))
		piece.connect("piece_selected", Callable(board, "_on_piece_selected"))
		self.visible = false
		collider.disabled = true
		print("black pawn promoted to ", text, "")
		return piece
	else:
		return null
		
		

func is_cleared(target_tile: Vector2i, current_pos: Vector2i) -> bool:
	var direction_vec = (target_tile - current_pos).sign()
	var current = current_pos + direction_vec
	var occupied = board.get_occupied()
	while current != target_tile:
		if occupied[current] != null:
			return false
		current += direction_vec
	return true
	
	
func get_moves()->Array:
	var moves = []
	var direction = -1
	var ahead = position_on_grid + Vector2i(0, direction)
	var occupied = board.get_occupied()
	if occupied[ahead] == null:
		moves.append(tilemap.map_to_local(ahead))
	
	var ahead2 = ahead + Vector2i(0, direction)
	if position_on_grid.y == 6 and occupied[ahead] == null and occupied[ahead2] == null:
		
		moves.append(tilemap.map_to_local(ahead2))
		
	for dx in [1,-1]:
		var diagnol = position_on_grid + Vector2i(dx, direction)
		if (diagnol.x < 0 or diagnol.x > 7 or diagnol.y < 0 or diagnol.y > 0):
			continue
		var piece = occupied[diagnol]
		if piece != null and piece.get_colour() != self.colour:
			moves.append(tilemap.map_to_local(diagnol))
			
	return moves
	
#todo:
#tidy up code
#implement moving diagnolly during takeovers 
#implement hashmap for tile tracking
#implement en passant
		

	
