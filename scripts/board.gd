extends Node2D

@onready var label := $Label
@onready var tilemap := $TileMap
@onready var button := $OptionButton
var selected_piece = null
var input_lock = false
var is_promotion = false
var occupied = {}
var turn = 0


#handles collison properly for when black pieces block
#need to fix so that when white pieces it takes over piece
func _unhandled_input(event):
	if input_lock:
		return
	if turn == 0:
		label.text = "White's turn"
	else :
		label.text = "Black's turn"
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not is_promotion: 
		var grid_pos = tilemap.local_to_map(tilemap.get_global_mouse_position())
		print("Clicked tile at: ", grid_pos)

		if selected_piece and selected_piece.is_selected and selected_piece.get_colour() == turn:
			#case when the tile trying to be moved to is unoccupied
			if occupied[grid_pos] == null:
				var grid2 = Vector2i(grid_pos.x, grid_pos.y)
				var previous_pos = selected_piece.get_pos()
				input_lock = true
				var checker = selected_piece.try_move_to(grid2, tilemap.map_to_local(grid2))
				if checker:
					if selected_piece._get_piece_type() == 0:
						var correct = 0 if turn == -1 else 7
						if grid2.y == correct:
							is_promotion = true
							button.get_ready()
							await button.everything_done
							print("returning control flow")
							is_promotion = false
					occupied[selected_piece.get_pos()]= selected_piece
					occupied[previous_pos] = null
					turn = 0 if selected_piece.get_colour() == -1 else -1
				selected_piece._unselect()
				input_lock = false
				selected_piece = null
			#elif for when occupied but by different colour
			elif occupied[grid_pos].get_colour() != selected_piece.get_colour():
				var grid2 = Vector2i(grid_pos.x, grid_pos.y)
				var prevous_pos = selected_piece.get_pos()
				var checker
				#checking for pawn takeover
				if (selected_piece._get_piece_type() == 0):
					input_lock = true
					checker = selected_piece.try_pawn_take_over(grid2, tilemap.map_to_local(grid2))
				else:
					input_lock = true
					checker = selected_piece.try_take_over(grid2, tilemap.map_to_local(grid2))
				if checker:
					if selected_piece._get_piece_type() == 0:
						var correct = 0 if turn == -1 else 7
						if grid2.y == correct:
							is_promotion = true
							button.get_ready()
							await button.everything_done
							print("not meow")
							is_promotion = false
					print("meow")
					var old_piece = occupied[grid_pos]
					old_piece.visible = false
					old_piece.set_deferred("monitoring", false)
					var shape = old_piece.get_collider()
					turn = 0 if selected_piece.get_colour() == -1 else -1
					if shape:
						shape.disabled = true
					else:
						print("couldnt find shape")
					occupied[selected_piece.get_pos()] = selected_piece
					occupied[prevous_pos] = null
				selected_piece._unselect()
				input_lock = false
				selected_piece = null
				#else for when selected piece same colour
			else:
				if selected_piece:
					selected_piece._unselect()
				selected_piece = null
				input_lock = false
		#case when piece not selected or piece not selected- bit redundant
		else: 
			if selected_piece:
				selected_piece._unselect()
			selected_piece = null
			input_lock = false
			
func get_occupied()->Dictionary:
	return occupied

func _on_piece_selected(piece: Area2D):
	if selected_piece and selected_piece != piece:	
		selected_piece._unselect()		
	selected_piece = piece
	selected_piece._select()

func _ready() -> void:
	label.text = "White's turn"
	button.connect("le_promote", Callable(self, "me_promote"))
	for x in range(8):
		for y in range(8):
			occupied[Vector2i(x,y)] = null
	for child in get_children():
		if child.has_signal("piece_selected"):
			child.connect("piece_selected", Callable(self, "_on_piece_selected"))
			var kid := child as Area2D
			var temp = child.get_pos()
			occupied[temp] = child
			
func me_promote(index):
	print("processing promote")
	var promoted = null
	promoted = selected_piece.promotion(selected_piece.get_pos(), selected_piece.global_position, index)
	if promoted != null:
		selected_piece = promoted
		
#logic for taking over pieces
#logic for promotion
#logic for en passant
#logic for black and white turn wise
#create stack to count points
#next step to create a white pawn and then implement taking over
	
