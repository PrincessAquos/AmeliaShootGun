extends Reference

class_name Directions

enum Direction {UP = -2, DOWN = 2, LEFT = -1, RIGHT = 1}

const dir_strings = {
	Direction.UP: "Up",
	Direction.DOWN: "Down",
	Direction.LEFT: "Left",
	Direction.RIGHT: "Right"
}

const dir_vectors = {
	Direction.UP: Vector2.UP,
	Direction.DOWN: Vector2.DOWN,
	Direction.LEFT: Vector2.LEFT,
	Direction.RIGHT: Vector2.RIGHT
}
