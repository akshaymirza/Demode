extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -400.0
var health = 100
var is_dead = false

@onready var animatedsprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Tambahkan gravitasi
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# 2. Jika mati, hanya jalankan gravitasi dan hentikan input
	if is_dead:
		move_and_slide()
		return 

	# 3. Handle loncat
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 4. Handle gerakan horizontal
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip sprite
	if direction > 0:
		animatedsprite.flip_h = false
	elif direction < 0:
		animatedsprite.flip_h = true
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Contoh cara memanggil fungsi mati (untuk testing)
	if health <= 0:
		die()

# FUNGSI DIE HARUS DI LUAR _PHYSICS_PROCESS
func die():
	if is_dead: 
		return # Jika sudah mati, jangan jalankan kode di bawah berkali-kali
	
	is_dead = true
	print("Karakter mati!")
	
	# MATIKAN TABRAKAN: Agar karakter jatuh menembus lantai
	set_collision_mask_value(1, false)
	
	# Beri efek lompat sedikit saat mati
	velocity.y = JUMP_VELOCITY * 0.5 
	
	# Jalankan animasi mati jika ada
	# animatedsprite.play("death")
