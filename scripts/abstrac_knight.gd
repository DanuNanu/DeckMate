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
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var board: Node2D = get_parent()
@onready var sprite:= $Sprite2D
@onready var highlight_map:= get_parent().get_node("Highlight")
@onready var tilemap: TileMap = get_parent().get_node("TileMap")
var offsets = [Vector2i(1,2), Vector2i(2,1), Vector2i(-1,2), Vector2i(1,-2), Vector2i(-1,-2), Vector2i(-2,1), Vector2i(2,-1), Vector2i(-2,-1)]

func _select()->void:
	is_selected = true
	
func _unselect()->void:
	is_selected = false
	sprite.modulate = Color(1,1,1)

func _set_piece_type(type: int):
	piece_type = type
	
func _get_piece_type() -> int:
	return piece_type

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

func _on_mouse_entered() -> void:
	is_hovered = true

func _on_mouse_exited() -> void:
	is_hovered = false

func get_moves()-> Array:
	var moves = []
	var occupied = board.get_occupied()
	for offset in offsets:
		var pos = position_on_grid + offset
		if pos.x < 0 or pos.x > 7 or pos.y < 0 or pos.y > 7:
			continue
		if occupied[pos] == null or occupied[pos].get_colour() != self.get_colour():
			moves.append(tilemap.map_to_local(pos))
	return moves
	 
	
