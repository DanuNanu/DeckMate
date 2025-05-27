extends Node2D

var layer = []

func clear():
	layer = []
	queue_redraw()

func _draw() -> void:
	for tiles in layer:
		draw_circle(tiles, 4, Color.GREEN)
	
func show_light(moves:Array) -> void:
	layer = moves
	queue_redraw()
	
	
	
