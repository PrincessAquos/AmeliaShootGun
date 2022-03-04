extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if event.is_pressed():
		start()
		queue_free()
	pass
	

func start():
	if Game.debug_mode:
		Debug.load_debug_dungeon()
	else:
		Game.load_file_select()
	queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
