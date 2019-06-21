extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime

export (PackedScene) var Expl

var velocity = Vector2()

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const max_rotation = 5
var timer = 0
var dir
var main
signal explosion
var player
signal damage_taken

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here	rotation = rotation #+ deg2rad(270)
	main = get_node("/root/Main")
	connect("explosion", main, "make_explosion")
	player = get_node("/root/Main/Player")
	connect("damage_taken", player, "damage_taken")
	

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()+deg2rad(270)
	$Lifetime.wait_time = lifetime
	velocity = _direction * speed
	$Lifetime.start()
	if (!player):
		player = get_node("/root/Main/Player")
	


func _process(delta):
	#print("process miss")
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	#rotation = rotation + 0.0001
	timer+= delta
	if(timer >=0.1):
		follow_player()
		timer = 0
	position += velocity * delta
		
func explode():
	
	queue_free()
	
func follow_player():
	
	if(!player):
		return
	var pos_player = player.get_position()
	dir = (pos_player - position).normalized()
	rotation = dir.angle()+deg2rad(270)
	velocity = dir * speed
	speed = clamp(speed * 1.15,0,300)
	

func _on_Lifetime_timeout():
	print("explode miss")
	emit_signal("explosion", Expl, global_position)
	explode()



func _on_Missile_body_entered(body):
	if body.owner.get_name() != "Boss":
		emit_signal("explosion", Expl, global_position)
		explode()
		if(body.get_name() == "Player"):
			emit_signal("damage_taken")
