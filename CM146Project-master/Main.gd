extends Node

export (PackedScene) var gun

func _on_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)

func _on_Boss_respawn_laser(laser, _position, _direction):
	var la = laser.instance()
	add_child(la)
	# print("added laser")
	la.start(_position, _direction)

func make_explosion(Expl, _position):
	var epl = Expl.instance()
	add_child(epl)
	epl.start(_position)
	
func gun_fell():
	var g = gun.instance()
	g.position = Vector2(randi()%600+200, randi()%300+100)
	add_child(g)
	pass
