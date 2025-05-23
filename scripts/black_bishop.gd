extends "res://scripts/abstract_bishop.gd"

signal piece_selected(Area2D)

func _ready() -> void:
	piece_type = Piece_type.BISHOP
	colour = Piece_colour.BLACK
	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if just_moved:
		just_moved = false
		return
	if is_hovered and event is InputEventMouseButton:
		if not is_selected: 
			var mouse_event := event as InputEventMouseButton
			if mouse_event.button_index== MOUSE_BUTTON_LEFT and mouse_event.pressed:
				is_selected = true
				emit_signal("piece_selected", self)
				print("black bishop selected at tile: ", position_on_grid)
 

func try_move_to(target_tile: Vector2i, tile_pos: Vector2)-> bool:
	var dx = abs(target_tile.x - position_on_grid.x)
	var dy = abs(target_tile.y - position_on_grid.y)
	if is_selected and dx == dy and dx != 0:
		just_moved = true
		position_on_grid = target_tile
		global_position = tile_pos
		print("Moved black bishop to ", position_on_grid, " (world position: ", global_position, ")")
		return true
	else:
		print("Invalid move")
		return false
		
func try_take_over(target_tile: Vector2i, tile_pos: Vector2) -> bool:
	var dx = abs(target_tile.x - position_on_grid.x)
	var dy = abs(target_tile.y - position_on_grid.y)
	if is_selected and dx == dy and dx != 0:
		just_moved = true
		position_on_grid = target_tile
		global_position = tile_pos
		print("Black Bishop takes over piece at ", position_on_grid, " (world position: ", global_position, ")")
		return true
	else:
		print("Invalid move")
		return false
	
