extends Area2D

# === Configuration ===
const TILE_SIZE := 16  # Make sure this matches your TileMap's cell size
var position_on_grid: Vector2i = Vector2i(1, 6)  # Initial tile coordinates (not pixels)
var is_selected = false
var is_hovered:bool = false
var just_moved:bool = false

signal piece_selected(Area2D)

@onready var tilemap: TileMap = get_parent().get_node("TileMap")  # Adjust this path if needed

# === Called when the piece is clicked ===
func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if just_moved:
		just_moved = false
		return
	if is_hovered and event is InputEventMouseButton:
		if not is_selected: 
			var mouse_event := event as InputEventMouseButton
			if mouse_event.button_index== MOUSE_BUTTON_LEFT and mouse_event.pressed:
				is_selected = true
				emit_signal("piece_selected", self)
				print("Dummy selected at tile: ", position_on_grid)
			

# === Called externally to attempt a move ===
func try_move_to(target_tile: Vector2i, tile_pos: Vector2):
	var dx = abs(target_tile.x - position_on_grid.x)
	var dy = abs(target_tile.y - position_on_grid.y)

	print("Attempting to move from ", position_on_grid, " to ", target_tile)

	# Only allow diagonal moves that aren't zero-distance
	if is_selected and dx == dy and dx != 0:
		just_moved = true
		position_on_grid = target_tile
		global_position = tile_pos
		print("Moved to ", position_on_grid, " (world position: ", global_position, ")")
	else:
		print("Invalid move")

func _on_mouse_entered() -> void:
	is_hovered = true
	print("hello")


func _on_mouse_exited() -> void:
	is_hovered = false
	print("bye")
	
func _unselect() -> void:
	print("meow")
	is_selected = false
	if not is_selected:	
		print("meow 2")
		
func _select() -> void:
	is_selected = true
		
