extends Area2D

@export var speed = 400
var direction = 1

func _physics_process(delta):
	# Peluru bergerak lurus sesuai arah
	position.x += speed * direction * delta

# Hubungkan signal body_entered dari Area2D ke fungsi ini
func _on_body_entered(body):
	if body.is_in_group("enemy"): # Pastikan musuh masuk grup "enemy"
		body.take_damage(20) # Panggil fungsi damage di musuh
		queue_free() # Hapus peluru setelah kena musuh

# Hubungkan signal screen_exited dari VisibleOnScreenNotifier2D
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Hapus peluru jika keluar layar
