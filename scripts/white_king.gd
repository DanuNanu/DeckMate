extends "res://scripts/abstract_king.gd"

signal piece_selected(Area2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piece_type = Piece_type.KING
	colour = Piece_colour.WHITE

func try_move_to(target_tile: Vector2i, tile_pos: Vector2)-> bool:
	var dx = abs(target_tile.x - position_on_grid.x)
	var dy = abs(target_tile.y - position_on_grid.y)
	if is_selected and (dx <=1 and dy <= 1) and (dx != 0 or dy != 0):
		if is_cleared(target_tile, position_on_grid):
			just_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("Moved White King to ", position_on_grid, " (world position: ", global_position, ")")
			return true
	print("Invalid move")
	sprite.modulate = Color(1,1,1)
	return false
		
func try_take_over(target_tile: Vector2i, tile_pos: Vector2) -> bool:
	var dx = abs(target_tile.x - position_on_grid.x)
	var dy = abs(target_tile.y - position_on_grid.y)
	if is_selected and (dx <=1 and dy <= 1) and (dx != 0 or dy != 0):
		if is_cleared(target_tile, position_on_grid):
			just_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("White King takes over piece at ", position_on_grid, " (world position: ", global_position, ")")
			return true
	print("Invalid move")
	sprite.modulate = Color(1,1,1)
	return false
		

func try_castelling(target_tile:Vector2i, tile_pos: Vector2) -> bool:
	var occupied = board.get_occupied()
	if (is_selected and has_moved == false and occupied[target_tile] != null and occupied[target_tile].colour == self.colour and occupied[target_tile]._get_piece_type() == 1 and not occupied[target_tile].has_moved):
		if is_cleared(target_tile, position_on_grid):
			var rook = occupied[target_tile] 
			if (occupied[target_tile].get_pos().x == 7) :
				just_moved = true
				has_moved = true
				rook.has_moved = true
				position_on_grid = Vector2i(6,0)
				global_position = tilemap.map_to_local(Vector2i(6,0))
				occupied[Vector2i(5,0)] = rook
				rook.position_on_grid = Vector2i(5,0)
				rook.global_setter(tilemap.map_to_local(Vector2i(5,0)))
				occupied[target_tile] = null
				highlight_map.clear()
				print("Castlled White rook with White king")
				return true
			else:
				just_moved = true
				has_moved = true
				rook.has_moved = true
				position_on_grid = Vector2i(2,0)
				global_position = tilemap.map_to_local(Vector2i(2,0))
				occupied[Vector2i(3,0)] = rook
				rook.position_on_grid = Vector2i(3,0)
				rook.global_setter(tilemap.map_to_local(Vector2i(3,0)))
				occupied[target_tile] = null
				highlight_map.clear()
				print("Castlled White rook with White king")
				return true
	print("Invalid move")
	sprite.modulate = Color(1,1,1)
	highlight_map.clear()
	return false



	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
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
				emit_signal("piece_selected", self)
				print("White King selected at tile: ", position_on_grid)
