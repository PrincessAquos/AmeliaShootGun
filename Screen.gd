extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var auto_scale = true
var scale = 1
var level_view:SubViewportContainer
var world:Node2D
var viewport:SubViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	level_view = get_node("LevelView")
	viewport = get_node("LevelView/SubViewport")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_Screen_resized():
#	if level_view != null:
#		var scale_vector = rect_size/level_view.rect_min_size
#		var min_factor = min(scale_vector.x, scale_vector.y)
#		scale = floor(min_factor)
#		#level_view.rect_scale = Vector2(scale, scale)
#		world.scale = Vector2(scale, scale)
#		#level_view.
