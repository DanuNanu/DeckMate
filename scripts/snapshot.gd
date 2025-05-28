extends Node2D
@onready var tilemap := get_parent().get_node("TileMap")

class PieceState:
	var type
	var colour
	var pos
	var just_moved

	func _init (_type, _colour, _pos, _just_moved):
		type = _type
		colour = _colour
		pos = _pos 
		just_moved = _just_moved

var turn = 0
var board_snapshot = {} #dictionary(Vector2i, PieceState)

func take_snapshot(board: Dictionary, _turn: int):
	turn = _turn
	board_snapshot.clear()
	for key in board.keys():
		var piece = board[key]
		if piece:
			board_snapshot[key] = PieceState.new(piece._get_piece_type(), piece.get_colour(), piece.get_pos(), piece.just_moved)
			

func restore_snapshop(board: Dictionary, parent_node: Node2D) -> void:
	for key in board.keys():
		var piece = board[key]
		if piece:
			piece.queue_free()
			board[key] = null
	
	
	for key in board_snapshot.keys():
		var snapshot = board_snapshot[key]
		var scene = get_scene(snapshot.colour, snapshot.type)
		
		var piece = scene.instantiate()
		parent_node.selected_piece = null
		piece.intial_pos_setter(snapshot.pos)
		piece.global_position = tilemap.map_to_local(snapshot.pos)
		piece.just_moved = snapshot.just_moved
		piece.is_selected = false
		parent_node.add_child(piece)
		board[key] = piece
		parent_node.turn = turn
	#
		
		
		
		
func get_scene(colour:int, type:int)->PackedScene:
	match[colour, type]:
		[0,0]: 
			print("nyope")
			return preload("res://scenes/white_pawn.tscn")
		[0,1]: return preload("res://scenes/white_rook.tscn")
		[0,2]: return preload("res://scenes/white_bishop.tscn")
		[0,3]: return preload("res://scenes/white_knight.tscn")
		[0,4]: return preload("res://scenes/white_queen.tscn")
		[0,5]: return preload("res://scenes/white_king.tscn")
		[-1,0] :return preload("res://scenes/black_pawn.tscn")
		[-1, 1]: return preload("res://scenes/black_rook.tscn")
		[-1, 2]: return preload("res://scenes/black_bishop.tscn")
		[-1, 3]: return preload("res://scenes/black_knight.tscn")
		[-1,4]: return preload("res://scenes/black_queen.tscn")
		[-1,5]: return preload("res://scenes/black_king.tscn")
		_:
			print(colour, type)
			return null
		
