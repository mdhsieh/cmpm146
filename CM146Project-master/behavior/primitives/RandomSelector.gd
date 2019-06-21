extends "res://behavior/primitives/BTNode.gd"

func _init(_name="RandomSelector").(_name):
	pass

func execute():
	var success = false
	var j = 0
	for i in range(btchildren.size()):
		j = randi() % btchildren.size()
		success = btchildren[j].execute()
		if success:
			return true
	return false