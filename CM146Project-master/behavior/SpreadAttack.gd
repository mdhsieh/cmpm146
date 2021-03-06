extends Node

const Sequence = preload("res://behavior/primitives/Sequence.gd")
const Selector = preload("res://behavior/primitives/Selector.gd")
const Check = preload("res://behavior/primitives/Check.gd")
const Action = preload("res://behavior/primitives/Action.gd")
const cooldown = 0.2
const lifetime = 10
const dir_inc = 1
var ent
var tree
var dir
var timer
var life_timer

func _init(_ent):
	name = "Behavior"
	ent = _ent

func _ready():
	tree = Selector.new()
	
	var lifetime_checker = Sequence.new()
	lifetime_checker.add_btchild(Check.new(funcref(self, "check_life"), null))
	lifetime_checker.add_btchild(Action.new(funcref(ent, "change_behavior"), null))
	
	var attack_checker = Sequence.new()
	attack_checker.add_btchild(Check.new(funcref(self, "check_timer"), null))
	attack_checker.add_btchild(Action.new(funcref(self, "attack"), null))
	
	tree.add_btchild(lifetime_checker)
	tree.add_btchild(attack_checker)
	
	dir = Vector2(0, 1)
	timer = 0.0
	life_timer = 0.0
	set_process(true)

func _process(delta):
	timer += delta
	life_timer += delta
	tree.execute()

func check_life(args):
	if life_timer >= lifetime:
		return true
	else:
		return false

func check_timer(args):
	if timer >= cooldown:
		return true
	else:
		return false

func attack(args):
	timer -= cooldown
	dir = dir.rotated(dir_inc)
	ent.shoot(dir)
	ent.shoot(dir.rotated(PI*0.5))
	ent.shoot(dir.rotated(PI))
	ent.shoot(dir.rotated(PI*1.5))