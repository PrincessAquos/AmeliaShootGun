extends Reference

class_name RoomSolutions
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

static func all_enemies_defeated(new_room):
	var room_complete = true
	for actor in new_room.actors:
		if !actor.actor.is_dead:
			room_complete = false
	return room_complete
