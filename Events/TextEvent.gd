extends Event

class_name TextEvent


# Declare member variables here. Examples:
var text:String
var pause = false

func _init(source, in_text).(source):
	text = in_text


func _start():
	pause = false
	return


func _unhandled_input(event):
	if event.is_action_pressed("move_jump"):
		complete = true


func _on_process(delta):
	if !pause:
		print(text)
		pause = true
	pass


func _is_finished():
	return complete
