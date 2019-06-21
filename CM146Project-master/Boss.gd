extends Node2D # KinematicBody2D

signal shoot

signal respawn_laser

signal gun_fell

export (PackedScene) var Bullet

export (PackedScene) var Missile
export (PackedScene) var Laser
# laser separate from bullet
const ChooseBehavior = preload("res://behavior/ChooseBehavior.gd")
var action_choice_tree

var disabled_gun

func _ready():
	var screensize = get_viewport_rect().size
	position.x = screensize.x / 2
	position.y = screensize.y / 2 - 100
	action_choice_tree = ChooseBehavior.new(self)
	action_choice_tree.call_deferred("execute")
	var main = get_node("/root/Main")
	connect("gun_fell", main, "gun_fell")

	# $LaserRespawnTimer.start()

func _process(delta):
	pass

func change_behavior(args):
	action_choice_tree.execute()
	return true

func set_behavior_node(args):
	$Behavior.queue_free()
	remove_child($Behavior)
	add_child(args.new_behavior.new(args.new_args))
	return true

func shoot(dir):
	emit_signal('shoot', Bullet, $BulletSpawnPoint.global_position, dir)

func shoot_missile(dir):
	emit_signal('shoot', Missile, get_node("gun_missile/spawnpoint_missile").global_position, dir)

func respawn_laser():
	emit_signal('respawn_laser', Laser, get_node("gun_laser/spawnpoint_laser").global_position, Vector2(0, 0))
	# print("sent out laser signal")

func move(args):
	position.x += args[0]
	position.y += args[1]

func disable():
	print("boss disabled")
	emit_signal('gun_fell')
	var gun = $gun_laser
	#gun.modulate = Color(0,0,0,0.6)
	are_disabled(gun)

func are_disabled(disabled_gun):
	disabled_gun.modulate = Color(0,0,0,0)

func rotate_boss(target):
	var pos_boss = target
	var dir = (target - global_position).normalized()
	rotation = dir.angle() + deg2rad(270)
