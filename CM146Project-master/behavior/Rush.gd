extends "res://Bullet.gd"

var ent
var rush_speed
var target
var timer
var left
var has_target

func _init(_ent):
	name = "Behavior"
	ent = _ent

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	rush_speed = 150
	timer = 0
	left = 4
	has_target = false

func _process(delta):
	timer += delta
	
	if timer < 1:
		_shake()
	elif timer < 3:
		_rush(delta)
	elif timer < 4:
		_shake()
	elif timer < 6:
		_rush(delta)
	elif timer < 7:
		_shake()
	elif timer < 9:
		_rush(delta)
	else:
		ent.change_behavior(null)

func _getNewTarget():
	var player = get_node("/root/Main/Player")
	if (!player):
		print("unable to find player")
		return Vector2()
	return player.get_position()
	
	
func _shake():
	ent.move([left, 0])
	left = -left
	has_target = false
	
func _rush(delta):
	if !has_target:
		target = _getNewTarget()
		has_target = true
	var targetVector = (target - ent.get_position())
	
	ent.rotate_boss(target)
	
	if targetVector.length() < rush_speed * delta:
		ent.move(targetVector)
	else:
		ent.move(targetVector.normalized() * rush_speed * delta)
