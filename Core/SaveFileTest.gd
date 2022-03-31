extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var testfile1 = SaveData.new(0)
	var testfile2 = SaveData.new(1)
	var testfile3 = SaveData.new(2)
	#testfile.read_save()
	testfile1.write_save()
	testfile2.write_save()
	testfile3.write_save()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
