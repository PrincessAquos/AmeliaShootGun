extends Character


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var change_dir_time = 2

var change_dir_timer = 0

# Called when the node enters the scene tree for the first time.
func _on_ready():
	super._on_ready()
	speed = 8
	if hurtbox.hitstun_timer > 0:
		print(hurtbox.hitstun_timer)


func _on_physics_process(delta):
	if change_dir_timer <= 0:
		change_dir_timer += change_dir_time
		for direction in move_dirs:
			move_dirs[direction] = false
		var testlist = [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT]
		move_dirs[testlist[randi() % 4]] = true
	change_dir_timer -= delta
	super._on_physics_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
