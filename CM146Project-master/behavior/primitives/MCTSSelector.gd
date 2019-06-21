extends Node

var node_id
var btchildren = []

func _init(_name=""):
	node_id = _name

func add_btchild(node):
	btchildren.append({
		"node":node,
		"score": 0,
		"visits": 0
	})

func execute():
	var success = false
	for child in btchildren:
		success = child.node.execute()
		if success:
			return true
	return false