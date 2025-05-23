extends Node2D

@onready var tilemap := $TileMap
var selected_piece = null
enum states{UNOCCUPIED = 0, OCCUPIED = 1}
var occupied = {}
#handles collison properly for when black pieces block
#need to fix so that when white pieces it takes over piece
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var grid_pos = tilemap.local_to_map(tilemap.get_global_mouse_position())
		print("Clicked tile at: ", grid_pos)

		if selected_piece and selected_piece.is_selected and occupied[grid_pos] == null:
			var grid2 = Vector2i(grid_pos.x, grid_pos.y)
			var previous_pos = selected_piece.get_pos()
			var checker = selected_piece.try_move_to(grid2, tilemap.map_to_local(grid2))
			selected_piece._unselect()
			if checker:
				occupied[selected_piece.get_pos()]= selected_piece
				occupied[previous_pos] = null
			selected_piece = null
		else: 
			if selected_piece:
				selected_piece._unselect()
			selected_piece = null

func _on_piece_selected(piece: Area2D):
	if selected_piece and selected_piece != piece:	
		selected_piece._unselect()		
	selected_piece = piece
	selected_piece._select()

func _ready() -> void:
	for x in range(7):
		for y in range(7):
			occupied[Vector2i(x,y)] = null
	for child in get_children():
		if child.has_signal("piece_selected"):
			child.connect("piece_selected", Callable(self, "_on_piece_selected"))
			var kid := child as Area2D
			var temp = child.get_pos()
			occupied[temp] = child
			
#todo
#logic for taking over pieces
#logic for promotion
#logic for en passant
#logic for black and white turn wise
#create stack to count points
#next step to create a white pawn and then implement taking over
	
