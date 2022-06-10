extends Event

class_name TextEvent


# Declare member variables here. Examples:
var title
var text:String
var printed = false
var textbox


func _init(source, in_title, in_text).(source):
	title = in_title
	text = in_text


func _start():
	printed = false
	textbox = TextBox.new(title, text)
	Game.hud.add_child(textbox)
	return


func _unhandled_input(event):
	if event.is_action_pressed("move_jump"):
		textbox.progress_text()
		if textbox.dismiss_text:
			complete = true
			textbox.queue_free()


func _on_process(delta):
	if !printed:
		print(text)
		printed = true
	pass


func _is_finished():
	return complete
