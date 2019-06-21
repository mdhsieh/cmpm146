extends Node

const RandomSelector = preload("res://behavior/primitives/RandomSelector.gd")
const Action = preload("res://behavior/primitives/Action.gd")
const HomingMissileAttack = preload("res://behavior/HomingMissileAttack.gd")
const SpreadAttack = preload("res://behavior/SpreadAttack.gd")
const LaserAttack = preload("res://behavior/LaserAttack.gd")
const Shockwave = preload("res://behavior/shockwave.gd")
const Rush = preload("res://behavior/Rush.gd")
var tree
var ent

func _init(_ent):
	ent = _ent
	tree = RandomSelector.new()
	tree.add_btchild(\
			Action.new(\
				funcref(ent, "set_behavior_node"),\
				{"new_behavior": HomingMissileAttack, "new_args": ent}))

	tree.add_btchild(\
			Action.new(\
				funcref(ent, "set_behavior_node"),\
				{"new_behavior": Rush, "new_args": ent}))

	tree.add_btchild(\
			Action.new(\
				funcref(ent, "set_behavior_node"),\
				{"new_behavior": LaserAttack, "new_args": ent}))

	tree.add_btchild(\
			Action.new(\
				funcref(ent, "set_behavior_node"),\
				{"new_behavior": Shockwave, "new_args": ent}))

	tree.add_btchild(\
			Action.new(\
				funcref(ent, "set_behavior_node"),\
				{"new_behavior": SpreadAttack, "new_args": ent}))

func execute():
	tree.execute()
