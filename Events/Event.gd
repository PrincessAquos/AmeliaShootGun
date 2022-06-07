extends Node

class_name Event

var source_obj
var actors
var id
var is_active = false
var complete = false
var acknowledged = false

func _init(source):
	source_obj = source


func _process(delta):
	if is_active:
		_on_process(delta)
		
		if _is_finished():
			complete = true
			if acknowledged:
				return_control()
		

func _on_process(delta):
	pass


func trigger():
	take_control()
	_start()
	is_active = true


# Same for all events; the inverse of _return_control()
func take_control():
	# Will need to treat nested events differently
	# Pauses AI and player control
	# Pauses physics
	pass


func ack():
	acknowledged = true


# Same for all events; the inverse of _take_control()
func return_control():
	is_active = false
	queue_free()
	# Will need to treat nested events differently
	# Resumes physics
	# Resumes player control
	pass


# NEW EVENTS OVERWRITE THIS
func _start():
	pass


func _is_finished():
	return true
