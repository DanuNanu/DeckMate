extends "res://scripts/abstract_rook.gd"

signal piece_selected(Area2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piece_type = Piece_type.ROOK
	colour = Piece_colour.BLACK



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
				var legal_moves = get_moves()
				highlight_map.show_light(legal_moves)
				emit_signal("piece_selected", self)
				print("black rook selected at tile: ", position_on_grid)
#plan for castelling
#1) check if either king or rook has been moved
#2) check if tile selected has king
#3) check if clear
#3) do castelling

func try_move_to(target_tile: Vector2i, tile_pos: Vector2)-> bool:
	var dx = target_tile.x - position_on_grid.x
	var dy = target_tile.y - position_on_grid.y
	var occupied = board.get_occupied()
	if is_selected and ((dx == 0 and dy != 0) or (dy == 0 and dx != 0)):
		if is_cleared(target_tile, position_on_grid):
			just_moved = true
			has_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("Moved black rook to ", position_on_grid, " (world position: ", global_position, ")")
			highlight_map.clear()
			return true
	print("Invalid move")
	sprite.modulate = Color(1,1,1)
	highlight_map.clear()
	return false
		
func try_take_over(target_tile: Vector2i, tile_pos: Vector2) -> bool:
	var dx = target_tile.x - position_on_grid.x
	var dy = target_tile.y - position_on_grid.y
	if is_selected and ((dx == 0 and dy != 0) or (dy == 0 and dx != 0)):
		if is_cleared(target_tile, position_on_grid):
			just_moved = true
			has_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("Black rook takes over piece at ", position_on_grid, " (world position: ", global_position, ")")
			highlight_map.clear()
			return true
	print("Invalid move")
	sprite.modulate = Color(1,1,1)
	highlight_map.clear()
	return false


func try_castelling(target_tile:Vector2i, tile_pos: Vector2) -> bool:
	var occupied = board.get_occupied()
	if (is_selected and has_moved == false and occupied[target_tile] != null and occupied[target_tile].colour == self.colour and occupied[target_tile]._get_piece_type() == 5 and not occupied[target_tile].has_moved):
		if is_cleared(target_tile, position_on_grid):
			var king = occupied[target_tile] 
			if (position_on_grid.x == 0) :
				just_moved = true
				has_moved = true
				king.has_moved = true
				position_on_grid = Vector2i(3,7)
				global_position = tilemap.map_to_local(Vector2i(3,7))
				occupied[Vector2i(2,7)] = king
				king.position_on_grid = Vector2i(2,7)
				king.global_setter(tilemap.map_to_local(Vector2i(2,7)))
				occupied[target_tile] = null
				highlight_map.clear()
				print("Castlled black rook with black king")
				return true
			else:
				just_moved = true
				has_moved = true
				king.has_moved = true
				position_on_grid = Vector2i(5,7)
				global_position = tilemap.map_to_local(Vector2i(5,7))
				occupied[Vector2i(6,7)] = king
				king.position_on_grid = Vector2i(6,7)
				king.global_setter(tilemap.map_to_local(Vector2i(6,7)))
				occupied[target_tile] = null
				highlight_map.clear()
				print("Castlled black rook with black king")
				return true
	print("Invalid move")
	sprite.modulate = Color(1,1,1)
	highlight_map.clear()
	return false
	


	
