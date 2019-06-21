extends Node

var ent
var life_timer = 6

func _init(_ent):
	name = "Behavior"
	ent = _ent

func _ready():
	ent.call_deferred("respawn_laser")
	set_process(true)

func _process(delta):
	life_timer -= delta
	if life_timer <= 0:
		ent.change_behavior(null)