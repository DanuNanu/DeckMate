extends "res://scripts/abstract_rook.gd"

signal piece_selected(Area2D)

func _ready() -> void:
	piece_type = Piece_type.ROOK
	colour = Piece_colour.WHITE


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
				print("white rook rook selected at tile: ", position_on_grid)
	
	
func try_move_to(target_tile: Vector2i, tile_pos: Vector2)-> bool:
	var dx = target_tile.x - position_on_grid.x
	var dy = target_tile.y - position_on_grid.y
	if is_selected and ((dx == 0 and dy != 0) or (dy == 0 and dx != 0)):
		if is_cleared(target_tile, position_on_grid):
			just_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("Moved White rook to ", position_on_grid, " (world position: ", global_position, ")")
			highlight_map.clear()
			return true
	print("Invalid move")
	highlight_map.clear()
	sprite.modulate = Color(1,1,1)
	return false
		
func try_take_over(target_tile: Vector2i, tile_pos: Vector2) -> bool:
	var dx = target_tile.x - position_on_grid.x
	var dy = target_tile.y - position_on_grid.y
	if is_selected and ((dx == 0 and dy != 0) or (dy == 0 and dx != 0)):
		if is_cleared(target_tile, position_on_grid):
			just_moved = true
			position_on_grid = target_tile
			global_position = tile_pos
			print("White rook takes over piece at ", position_on_grid, " (world position: ", global_position, ")")
			highlight_map.clear()
			return true
	print("Invalid move")
	highlight_map.clear()
	sprite.modulate = Color(1,1,1)
	return false
