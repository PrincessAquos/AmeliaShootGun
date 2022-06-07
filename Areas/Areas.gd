extends Reference

class_name Areas

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const maps = {
	"dungeon_manor": "res://Areas/MisteavousManor.tscn",
	
	"debug_old": "res://Objects/LevelObjects/DebugDungeon.tscn",
	"debug_default": "res://Objects/LevelObjects/Dungeon.tscn",
	"debug_event": "res://Areas/Debug/EventTest.tscn",
}

const MisteavousManor:PackedScene = preload("res://Areas/MisteavousManor.tscn")

static func load_area(area_id:String):
	var new_area:PackedScene = load(maps[area_id])
	return new_area.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
