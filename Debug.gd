extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var debug_dungeon:PackedScene = preload("res://Objects/LevelObjects/Dungeon.tscn")
var dungeon_path = "LevelView/Viewport/nudge"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_debug_dungeon():
	var instanced_dungeon = debug_dungeon.instance()
	#print(get_tree().current_scene.name)
	get_tree().current_scene.get_node("LevelView/Viewport/nudge").add_child(instanced_dungeon)
	Game.physics_step_counter = 0
	Game.do_load_step = true
	pass
