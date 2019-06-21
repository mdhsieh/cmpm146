# currently extending Bullet and adding AnimatedSprite

extends "res://Bullet.gd"

# extends Area2D

# inherited Sprite and velocity unused
# var velocity = Vector2()

var screensize

# laser spawns every 8 seconds, waits 2.5 seconds before firing
var charging

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	speed = 0
	
	# hide laser before starting game or starting laser
	hide()
	
	screensize = get_viewport_rect().size
	# arbitrary position, can change later
	# boss positon: (screensize.x / 2, screensize.y / 2 - 100)
	position.x = screensize.x / 2
	position.y = screensize.y / 2 - 100
	
	"""
	moved to start()
	
	# speed in frames per second
	$AnimatedSprite.frames.set_animation_speed("shooting", 10)
	#print($AnimatedSprite.frames.get_animation_speed("shooting"))
	rotation = 0
	
	$AnimatedSprite.animation = "shooting"
	charging = true
	
	# charge time needs to be > lifetime
	# wait time set to 2.5
	$ChargeTimer.start()
	
	print("ready laser")
	"""
	

func start(_position, _direction):
	show()
	# print("starting laser")
	# speed in frames per second
	$AnimatedSprite.frames.set_animation_speed("shooting", 10)
	#print($AnimatedSprite.frames.get_animation_speed("shooting"))
	rotation = 0
	
	$AnimatedSprite.animation = "shooting"
	charging = true
	
	# charge time needs to be > lifetime
	# wait time set to 2.5
	$ChargeTimer.start()
	
	
	# position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	# velocity = _direction * speed

func _process(delta):
	# position += velocity * delta
	
	# laser is ready to fire
	if charging == false:
		$AnimatedSprite.play()
	
		rotation = rotation + PI / 36
	
		if $AnimatedSprite.animation == "shooting" and $AnimatedSprite.frame == 6:
			$AnimatedSprite.stop()
			# $AnimatedSprite.animation = "final beam"
	
func explode():
	queue_free()

"""
func _on_Bullet_body_entered(body):
	# when hit wall
	explode()
	# otherwise, if hit boss or player
	# if body.has_method("take_damage"):
		# body.take_damage(body)
"""

# laser stops firing after a certain time
func _on_Lifetime_timeout():
	explode()
	charging = true

# laser only starts firing after a certain time
# gives player warning
func _on_ChargeTimer_timeout():
	charging = false
	# print("finished charging")
	# laser time set to 2
	$Lifetime.start()


func _on_Laser_body_entered(body):
	if body.get_name() != "Boss" and $AnimatedSprite.animation == "shooting" and $AnimatedSprite.frame == 6:
		#print("laser dmg")
		pass
