extends Camera2D

# Memakai tanda @ yang benar untuk Godot 4
@onready var tilemap = get_node_or_null("../../TileMap") 

func _ready():
	# Cek dulu, kalau node TileMap beneran eksis di map ini, baru jalankan pembatas kamera
	if tilemap != null:
		# 1. Mendapatkan area yang digunakan oleh TileMap (dalam satuan cell/kotak)
		var map_rect = tilemap.get_used_rect()
		
		# 2. Mendapatkan ukuran satu cell (misalnya 16x16 atau 64x64 pixel)
		var cell_size = tilemap.tile_set.tile_size
		
		# 3. Menghitung batas dalam pixel (Cell * Ukuran Cell)
		limit_left = map_rect.position.x * cell_size.x
		limit_right = map_rect.end.x * cell_size.x
		limit_top = map_rect.position.y * cell_size.y
		limit_bottom = map_rect.end.y * cell_size.y
		print("--- KAMERA: Mode pintar aktif memakai pembatas TileMap ---")
	else:
		# Jika tidak ada TileMap, kamera berjalan normal tanpa batas otomatis
		print("--- KAMERA: Mode normal aktif (TileMap tidak ditemukan di map ini) ---")
