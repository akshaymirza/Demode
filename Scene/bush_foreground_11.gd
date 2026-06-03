extends Area2D

# Membaca node Sprite2D bernama IconE yang ada di bawah semak
@onready var popup_icon = $IconE

var player_is_near : bool = false
var tween : Tween # Variabel untuk menyimpan data animasi melayang

func _ready() -> void:
	# Hubungkan sensor tabrakan player
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Pastikan ikon papan Canva sembunyi saat game baru mulai
	if popup_icon:
		popup_icon.hide()

func _process(_delta: float) -> void:
	# Jika player dekat dan menekan tombol E di keyboard, langsung pindah map
	if player_is_near and Input.is_key_pressed(KEY_E):
		pindah_ke_level_lain()

func _on_body_entered(body: Node2D) -> void:
	# Cek apakah yang menyentuh semak adalah player
	if body.is_in_group("player") or body.name.to_lower().contains("character") or body.name.to_lower().contains("player"):
		player_is_near = true
		
		# Tampilkan papan buatan Canva dan jalankan animasi naik-turun halus
		if popup_icon:
			popup_icon.show()
			mulai_animasi_melayang()
			
		print("--- SENSOR: Player mendekat, Papan E muncul! ---")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") or body.name.to_lower().contains("character") or body.name.to_lower().contains("player"):
		player_is_near = false
		
		# Sembunyikan papan kembali dan matikan animasinya
		if popup_icon:
			popup_icon.hide()
			if tween:
				tween.kill()
				
		print("--- SENSOR: Player menjauh, Papan E hilang ---")

# Fungsi membuat papan Canva kamu bergoyang melayang naik-turun halus (floating effect)
func mulai_animasi_melayang() -> void:
	if tween:
		tween.kill() # Bersihkan sisa animasi lama jika ada
	
	tween = create_tween().set_loops() # Membuat animasi looping selamanya
	
	var posisi_awal_y = popup_icon.position.y
	
	# Naik ke atas 5 pixel selama 0.6 detik, lalu turun lagi ke posisi semula
	tween.tween_property(popup_icon, "position:y", posisi_awal_y - 5, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(popup_icon, "position:y", posisi_awal_y, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func pindah_ke_level_lain() -> void:
	print("--- TELEPORT: Meluncur ke Level 2! ---")
	get_tree().change_scene_to_file("res://Scene/node_2d.tscn")
