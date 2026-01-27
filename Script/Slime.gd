extends Node2D

const SPEED = 60
var direction = 1
var health = 10

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
# Fungsi ini akan berjalan saat ada objek (body) masuk ke Area2D slime


func _on_area_2d_body_entered(body):
	# Cek apakah objek yang menyentuh slime adalah pemain
	# Kita asumsikan pemain memiliki variabel 'health'
	if body.name == "Player" or body.has_method("die") or "health" in body:
		body.health -= 10
		print ("healt -10")
		# Jika kamu ingin memastikan fungsi die() dipanggil saat darah 0
		if body.health <= 0 and body.has_method("die"):
			body.die()
