extends Control

var do_start = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	do_start = false
	pass # Replace with function body.


func _physics_process(delta):
	if do_start:
		start()


func _unhandled_input(event):
	if event.is_pressed():
		do_start = true
	pass
	

func start():
	if Game.debug_mode:
		Debug.load_debug_dungeon()
	else:
		Game.load_file_select()
	#Debug.load_debug_dungeon()
	queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
