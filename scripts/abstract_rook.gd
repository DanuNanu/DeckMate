extends Area2D
var is_selected = false
@export var position_on_grid = Vector2i.ZERO
var is_hovered = false
var just_moved = false
enum Piece_type {PAWN = 0, ROOK = 1, KNIGHT = 2, BISHOP = 3, QUEEN = 4, KING = 5}
enum Piece_colour {WHITE = 0, BLACK = -1}
var piece_type 
var colour
var has_moved = false
const TILE_SIZE = 16
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var board: Node2D = get_parent()
@onready var highlight_map:= get_parent().get_node("Highlight")
@onready var tilemap: TileMap = get_parent().get_node("TileMap")
@onready var sprite:= $Sprite2D
var offsets = [
	Vector2i(1, 0),   
	Vector2i(-1, 0), 
	Vector2i(0, 1),   
	Vector2i(0, -1)   
]


func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false


func _select()->void:
	is_selected = true
	
func _unselect()->void:
	highlight_map.clear()
	sprite.modulate = Color(1,1,1)
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

func is_cleared(target_tile: Vector2i, current_pos: Vector2i) -> bool:
	var direction_vec = (target_tile - current_pos).sign()
	var current = current_pos + direction_vec
	var occupied = board.get_occupied()
	while current != target_tile:
		if occupied[current] != null:
			return false
		current += direction_vec
	return true
	
func global_setter(pos: Vector2) -> void:
	global_position = pos
	
func get_moves() -> Array:
	var moves = []
	var occupied = board.get_occupied()
	for offset in offsets:
		var step = 1
		while true:
			var new_pos = position_on_grid + offset * step
			if new_pos.x < 0 or new_pos.x > 7 or new_pos.y < 0 or new_pos.y > 7:
				break  
			if occupied.has(new_pos) and occupied[new_pos] != null:
				if occupied[new_pos].get_colour() != self.get_colour():
					moves.append(tilemap.map_to_local(new_pos))  
				break 
			else:
				moves.append(tilemap.map_to_local(new_pos)) 
			step += 1
	return moves
