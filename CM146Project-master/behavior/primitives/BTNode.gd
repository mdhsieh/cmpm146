extends Node

var node_id
var btchildren = []

func _init(_name=""):
	node_id = _name

func add_btchild(node):
	btchildren.append(node)

func execute():
	return true