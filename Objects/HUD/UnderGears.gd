extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var num_gears:int = 3: set = set_num_gears

var anim_tile_size = Vector2(8,8)

var tiles = {
	0: Vector2(0, 8),
	1: Vector2(0, 0),
	2: Vector2(8, 0),
	3: Vector2(8, 8),
	4: Vector2(0, 16),
	5: Vector2(0, 24),
	6: Vector2(8, 24),
	7: Vector2(8, 16),
	8: Vector2(0, 32),
	9: Vector2(8, 32)
}

@onready var sprite_node:AnimatedSprite2D = null

func _draw():
	if sprite_node != null:
		var gear_count = 0
		var next_top_pos = Vector2.ZERO
		var next_bot_pos = anim_tile_size
		draw_top_gear(next_top_pos, true, (gear_count + 1) >= num_gears)
		next_top_pos += Vector2(anim_tile_size.x * 2, 0)
		gear_count += 1
		while gear_count < num_gears:
			draw_bottom_gear(next_bot_pos, false, (gear_count + 1) >= num_gears)
			next_bot_pos += Vector2(anim_tile_size.x * 2, 0)
			gear_count += 1
			if gear_count < num_gears:
				draw_top_gear(next_top_pos, false, (gear_count + 1) >= num_gears)
				next_top_pos += Vector2(anim_tile_size.x * 2, 0)
				gear_count += 1

func draw_gear_portion(pos, tile, front_layer=false):
	if front_layer:
		draw_texture_rect_region(sprite_node.sprite_frames.get_frame_texture(sprite_node.animation, sprite_node.frame), Rect2(pos, Vector2(8, 8)), Rect2(tile, Vector2(8, 8)))
	else:
		draw_texture_rect_region(sprite_node.sprite_frames.get_frame_texture("rust", sprite_node.frame), Rect2(pos, Vector2(8, 8)), Rect2(tile, Vector2(8, 8)))
	pass

func draw_top_gear(pos, first=true, last=true, front_layer=false, portions=4):
	match portions:
		4:
			if last:
				draw_gear_portion(pos + anim_tile_size, tiles[3], front_layer)
			draw_gear_portion(Vector2(pos.x + anim_tile_size.x, pos.y), tiles[2], front_layer)
			draw_gear_portion(Vector2(pos.x, pos.y), tiles[1], front_layer)
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[0], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[9], front_layer)
		3:
			draw_gear_portion(Vector2(pos.x + anim_tile_size.x, pos.y), tiles[2], front_layer)
			draw_gear_portion(Vector2(pos.x, pos.y), tiles[1], front_layer)
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[0], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[9], front_layer)
		2:
			draw_gear_portion(Vector2(pos.x, pos.y), tiles[1], front_layer)
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[0], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[9], front_layer)
		1:
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[0], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[9], front_layer)
	return


func draw_bottom_gear(pos, first=true, last=true, front_layer=false, portions=4):
	match portions:
		4:
			if last:
				draw_gear_portion(pos + Vector2(anim_tile_size.x, 0), tiles[7], front_layer)
			draw_gear_portion(pos + anim_tile_size, tiles[6], front_layer)
			draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[5], front_layer)
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[4], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[8], front_layer)
		3:
			draw_gear_portion(pos + anim_tile_size, tiles[6], front_layer)
			draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[5], front_layer)
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[4], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[8], front_layer)
		2:
			draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[5], front_layer)
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[4], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[8], front_layer)
		1:
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[4], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[8], front_layer)
	
	
	return



# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_node = get_node("AnimatedSprite2D")
	pass # Replace with function body.


func set_num_gears(new_val):
	num_gears = new_val
	queue_redraw()


func _on_AnimatedSprite_frame_changed():
	queue_redraw()
	return
