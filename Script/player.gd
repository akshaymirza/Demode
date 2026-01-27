extends CharacterBody2D

# --- VARIABEL ---
const SPEED = 180.0
const JUMP_VELOCITY = -250.0
var health = 100
var is_dead = false

# State Attack
var is_attacking = false

# Dash
const DASH_SPEED = 600
const DASH_CD = 0.5
const DASH_DURATION = 0.2
var is_dashing = false
var can_dash = true

# Double Jump
var countjump = 0
var maxjump = 2

@onready var animatedsprite = $AnimatedSprite2D

# --- FUNGSI SERANG ---
func perform_attack(anim_name: String):
	is_attacking = true
	animatedsprite.play(anim_name)
	
	# Menunggu animasi selesai
	await animatedsprite.animation_finished
	is_attacking = false

# --- FUNGSI DASH ---
func start_dash():
	is_dashing = true
	can_dash = false
	var dash_direction = -1 if animatedsprite.flip_h else 1
	velocity.x = dash_direction * DASH_SPEED
	velocity.y = 0 
	await get_tree().create_timer(DASH_DURATION).timeout
	is_dashing = false
	await get_tree().create_timer(DASH_CD).timeout
	can_dash = true

# --- LOGIKA UTAMA ---
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		countjump = 0
		
	if is_dead:
		move_and_slide()
		return 

	# 1. Logika Input Serang
	if not is_dashing:
		if Input.is_action_just_pressed("attack") and not is_attacking:
			perform_attack("Melee")
		if Input.is_action_just_pressed("skill") and not is_attacking:
			perform_attack("Range")

	# 2. Logika Dash (Tetap mengunci pergerakan manual)
	if Input.is_action_just_pressed("dash") and can_dash and not is_attacking:
		start_dash()

	if is_dashing:
		move_and_slide()
		return
		
	# 3. Logika Lompat (Bisa lompat meski sedang attack)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or countjump < maxjump:
			velocity.y = JUMP_VELOCITY
			countjump += 1
			# Hanya play animasi jump jika tidak sedang attack
			if not is_attacking:
				animatedsprite.play("Jump")

	# 4. Handle gerakan horizontal (KINI AKTIF MESKI SEDANG ATTACK)
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		# Balik arah sprite (Hanya jika tidak sedang attack agar arah hadap tidak aneh saat menyerang)
		# Atau hapus 'and not is_attacking' jika ingin bisa balik badan saat nyerang
		if not is_attacking:
			animatedsprite.flip_h = (direction < 0)
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 5. Handle Animasi Dasar
	# Logika: Mainkan animasi gerak/idle HANYA jika is_attacking bernilai FALSE
	if not is_attacking:
		if not is_on_floor():
			animatedsprite.play("Jump")
		elif direction != 0:
			animatedsprite.play("Walk")
		else:
			animatedsprite.play("Idle")
		
	move_and_slide()
	
	if health <= 0:
		die()

func die():
	if is_dead: return 
	is_dead = true
	set_collision_mask_value(1, false)
	velocity.y = JUMP_VELOCITY * 0.5
