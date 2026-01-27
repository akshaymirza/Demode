extends Node2D

const SPEED = 60
var direction = 1
var health = 10

@onready var ray_cast_right = $RayCastright
@onready var ray_cast_left = $RayCastleft
@onready var animatedsprite = $AnimatedSprite2D

func _process(delta):
	# 1. LOGIKA PATROLI
	if ray_cast_right.is_colliding():
		direction = -1
		animatedsprite.flip_h = true
	
	if ray_cast_left.is_colliding():
		direction = 1
		animatedsprite.flip_h = false
	
	# 2. GERAKKAN GOLEM
	position.x += direction * SPEED * delta
	
	# 3. MAINKAN ANIMASI
	# Pastikan di SpriteFrames kamu sudah membuat animasi bernama "walk"
	if direction != 0:
		animatedsprite.play("walk")
	else:
		animatedsprite.play("idle") # Jika suatu saat Golem berhenti

func _on_hit_box_body_exited(body: Node2D) -> void:
	if "health" in body:
		body.health -= 10
		print("Health target berkurang, sisa: ", body.health)
		
		if body is CharacterBody2D:
			var knockback_force = 500
			var knockback_dir = (body.global_position - global_position).normalized()
			body.velocity = knockback_dir * knockback_force
			
			if body.has_method("move_and_slide"):
				body.move_and_slide()
		
		if body.health <= 0:
			if body.has_method("die"):
				body.die()
			else:
				print("Target mati")
