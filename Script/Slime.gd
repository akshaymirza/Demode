extends Node2D

const SPEED = 60
var direction = 1

@onready var ray_cast_right = $RayCastright
@onready var ray_cast_left = $RayCastleft
@onready var animatedsprite = $animatedsprite2d

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animatedsprite.flip_h = true
	
	if ray_cast_left.is_colliding():
		direction = 1
		animatedsprite.flip_h = false
	
	position.x += direction * SPEED * delta
