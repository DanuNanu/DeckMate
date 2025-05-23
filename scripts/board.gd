extends Node2D

@onready var tilemap := $TileMap
var selected_piece = null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var grid_pos = tilemap.local_to_map(tilemap.get_global_mouse_position())
		print("Clicked tile at: ", grid_pos)

		if selected_piece and selected_piece.is_selected:
			var grid2 = Vector2i(grid_pos.x, grid_pos.y)
			selected_piece.try_move_to(grid2, tilemap.map_to_local(grid2))
			selected_piece._unselect()
			selected_piece = null
		else: 
			selected_piece = null

func _on_piece_selected(piece: Area2D):
	selected_piece = piece

func _ready() -> void:
	for child in get_children():
		if child.has_signal("piece_selected"):
			child.connect("piece_selected", Callable(self, "_on_piece_selected"))
	
