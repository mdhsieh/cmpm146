extends "res://behavior/primitives/BTNode.gd"

var act
var args

func _init(_act, _args, _name="Action").(_name):
	act = _act
	args = _args

func execute():
	return act.call_func(args)