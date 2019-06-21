extends "res://behavior/primitives/BTNode.gd"

func _init(_name="Selector").(_name):
	pass

func execute():
	var success = false
	for child in btchildren:
		success = child.execute()
		if success:
			return true
	return false