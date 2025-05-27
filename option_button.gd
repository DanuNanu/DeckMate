extends OptionButton

signal le_promote(index: int)
signal everything_done
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_item("Queen") #0
	add_item("Rook") #1
	add_item("Knight") #2
	add_item("Bishop") #3
	disabled = true
	visible = false
	
	
func get_ready():
		disabled = false
		select(-1)
		visible = true
		return
		#now await for everything_completed in board script
		#so that everything is paused until user selects an option
		# for promotion ensuring order of execution is maintained
		
		
	
#first emit signal to call the promotion function
#on board's script
#then once that is done upon returning, 
#signal to the board to continue working 
#as all functions that need to completed
#prior to the control flow returning back to
#where it stopped on board is done
func _on_item_selected(index: int) -> void:
	print("input accepted")
	emit_signal("le_promote", index)
	disabled = true
	visible = false
	emit_signal("everything_done")
