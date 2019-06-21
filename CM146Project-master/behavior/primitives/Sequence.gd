extends "res://behavior/primitives/BTNode.gd"

func _init(_name="Sequence").(_name):
	pass

func execute():
	var success = true
	for child in btchildren:
		success = child.execute()
		if !success:
			return false
	return true