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


@onready var tilemap: TileMap = get_parent().get_node("TileMap")


func _select()->void:
	is_selected = true
	
func _unselect()->void:
	is_selected = false

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
