extends Event

class_name TextEvent


# Declare member variables here. Examples:
var text:String
var printed = false

func _init(source, in_text).(source):
	text = in_text


func _start():
	printed = false
	return


func _unhandled_input(event):
	if event.is_action_pressed("move_jump"):
		complete = true


func _on_process(delta):
	if !printed:
		print(text)
		printed = true
	pass


func _is_finished():
	return complete
