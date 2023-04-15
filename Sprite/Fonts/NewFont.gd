@tool
extends Node

class_name CreateFont
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var bitmapfont:FontFile
@export var base_image:CompressedTexture2D
@export var characters:String
@export var char_size:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		#var font = load("res://Sprite/Fonts/InventoryNumbers.tres")
		var texture = base_image
		var chars = characters
		bitmapfont.add_texture(texture)
		for i in range (0, chars.length()):
			bitmapfont.add_char(chars.ord_at(i), 0, Rect2(char_size.x * i, 0, char_size.x, char_size.y), Vector2(0, 0), 8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
