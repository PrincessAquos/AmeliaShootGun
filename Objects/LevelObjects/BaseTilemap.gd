extends TileMap

enum PhysicsLayers {
	WALL = 0,
	FLOOR = 1,
	RAISED = 2
}

var collisions_parent
var previous_player_altitude = 0

func _use_tile_data_runtime_update(layer, coords):
	var current_player_altitude = Game.player.altitude
	if current_player_altitude != previous_player_altitude:
		var tile = get_cell_tile_data(layer, coords)
		var tile_height = tile.get_custom_data("height")
		
		var tile_was_lower = tile_height <= previous_player_altitude
		var tile_currently_lower = tile_height <= current_player_altitude
		
		
		#if tile_was_lower != tile_currently_lower:
		if tile_currently_lower:
			return true
		
	return false

func _tile_data_runtime_update(layer, coords, tile_data):
	print("I'm in layer: " + str(layer) + " with coordinates: " + str(coords))
	tile_data.modulate = Color(0, 0, 0, 1)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	collisions_parent = Node2D.new()
	collisions_parent.name = "Collisions"
	add_child(collisions_parent)
	var data = get_cell_tile_data(0, Vector2i(5, 5))
	if data:
		if data.get_collision_polygons_count(PhysicsLayers.FLOOR) > 0:
			#var this_collision = StaticBody2D.new()
			#this_collision.create_shape_owner()
			pass
	pass # Replace with function body.


func _physics_process(delta):
	force_update()
	previous_player_altitude = Game.player.altitude
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
