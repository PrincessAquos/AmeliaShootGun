extends Node2D

export var current_health:int = 9 setget set_health

export var shine_interval:float = 2
export var shine_speed:float = 200
var shine_timer = 0


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

onready var sprite_node:AnimatedSprite = null


func _draw():
	if sprite_node != null:
		var curr_health_count = current_health
		var next_top_pos = Vector2.ZERO
		var next_bot_pos = anim_tile_size
		var is_first = true
		var is_last = false
		var portions = 4
		
		while curr_health_count > 0:
			if curr_health_count <= 4:
				portions = curr_health_count
				is_last = true
			draw_top_gear(next_top_pos, is_first, is_last, true, portions)
			curr_health_count -= 4
			is_first = false
			next_top_pos += Vector2(anim_tile_size.x * 2, 0)
			
			if curr_health_count <= 4:
				portions = curr_health_count
				is_last = true
			draw_bottom_gear(next_bot_pos, is_first, is_last, true, portions)
			curr_health_count -= 4
			next_bot_pos += Vector2(anim_tile_size.x * 2, 0)
		#draw_gear_portion(Vector2(0, 8), tiles[0])
		#draw_gear_portion(Vector2(0, 0), tiles[1])
		#draw_gear_portion(Vector2(8, 0), tiles[2])
		#draw_gear_portion(Vector2(8, 8), tiles[3])
		#draw_bottom_gear(Vector2(8,8), false, false)
		#draw_gear_portion(Vector2(8, 8), tiles[8])
		#draw_gear_portion(Vector2(8, 16), tiles[5])
		#draw_gear_portion(Vector2(16, 16), tiles[6])
		#draw_gear_portion(Vector2(16, 8), tiles[7])
		
		#draw_gear_portion(Vector2(16, 8), tiles[9])
		
		#draw_top_gear(Vector2(16, 0), false, true)
		#draw_gear_portion(Vector2(16, 0), tiles[1])
		#draw_gear_portion(Vector2(24, 0), tiles[2])
		#draw_gear_portion(Vector2(24, 8), tiles[3])
		#draw_texture_rect_region(sprite_node.frames.get_frame(sprite_node.animation, sprite_node.frame), Rect2(Vector2.ZERO, Vector2(8, 8)), Rect2(Vector2.ZERO, Vector2(8, 8)))
		#draw_texture_rect_region(sprite_node.frames.get_frame(sprite_node.animation, sprite_node.frame), Rect2(Vector2(8, 0), Vector2(8, 8)), Rect2(Vector2(8,0), Vector2(8, 8)))
		pass
	pass


func draw_gear_portion(pos, tile, front_layer=false):
	if front_layer:
		draw_texture_rect_region(sprite_node.frames.get_frame(sprite_node.animation, sprite_node.frame), Rect2(pos, Vector2(8, 8)), Rect2(tile, Vector2(8, 8)))
	else:
		draw_texture_rect_region(sprite_node.frames.get_frame("rust", sprite_node.frame), Rect2(pos, Vector2(8, 8)), Rect2(tile, Vector2(8, 8)))
	pass

func draw_top_gear(pos, first=true, last=true, front_layer=false, portions=4):
	match portions:
		4:
			if last:
				draw_gear_portion(pos + anim_tile_size, tiles[3], front_layer)
			continue
		4, 3:
			draw_gear_portion(Vector2(pos.x + anim_tile_size.x, pos.y), tiles[2], front_layer)
			continue
		4, 3, 2:
			draw_gear_portion(Vector2(pos.x, pos.y), tiles[1], front_layer)
			continue
		4, 3, 2, 1:
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
			continue
		4, 3:
			draw_gear_portion(pos + anim_tile_size, tiles[6], front_layer)
			continue
		4, 3, 2:
			draw_gear_portion(Vector2(pos.x, pos.y + anim_tile_size.y), tiles[5], front_layer)
			continue
		4, 3, 2, 1:
			if first:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[4], front_layer)
			else:
				draw_gear_portion(Vector2(pos.x, pos.y), tiles[8], front_layer)
	
	
	return


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_node = get_node("UnderGears/AnimatedSprite")
	get_node("UnderGears").sprite_node = sprite_node
	get_node("UnderGears").update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite_node.speed_scale = Game.game_speed
	shine_timer += delta
	if shine_timer > shine_interval:
		shine_timer -= shine_interval
		get_node("Light2D").position = Vector2.ZERO
	get_node("Light2D").position += Vector2(shine_speed * delta, 0)
	return


func set_health(new_val):
	current_health = new_val
	update()
	return


func _on_AnimatedSprite_frame_changed():
	update()
	return
