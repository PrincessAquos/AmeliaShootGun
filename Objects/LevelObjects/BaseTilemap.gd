extends TileMap

enum PhysicsLayers {
	WALL = 0,
	FLOOR = 1,
	RAISED = 2
}

var collisions_parent
var previous_player_altitude = 0
