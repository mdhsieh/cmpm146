extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var dir
var ent
var dir_inc
var timer
var lifetimer
var cooldown = 2

func _init(_ent):
	name = "Behavior"
	ent = _ent
	dir = Vector2(0, 1)
	dir_inc = PI/50
	timer = 0
	lifetimer = 5
	

func _process(delta):
	timer += delta
	lifetimer -= delta
	if lifetimer < 0:
		ent.change_behavior(null)
	elif timer > cooldown:
		timer -= cooldown
		_attack()

func _ready():
	pass


func _attack():
	var i = 0
	while i < 100:
		ent.shoot(dir)
		dir = dir.rotated(dir_inc)
		i += 1

