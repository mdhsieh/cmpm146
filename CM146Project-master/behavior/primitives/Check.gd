extends "res://behavior/primitives/BTNode.gd"

var cond
var args

func _init(_cond, _args, _name="Check").(_name):
	cond = _cond
	args = _args

func execute():
	return cond.call_func(args)