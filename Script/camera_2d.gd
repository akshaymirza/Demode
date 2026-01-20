extends Camera2D

# Kita akan mengambil referensi ke TileMap
# Pastikan nama "TileMap" di bawah sesuai dengan nama node TileMap kamu
@onready var tilemap = get_node("../../TileMap") 

func _ready():
	# 1. Mendapatkan area yang digunakan oleh TileMap (dalam satuan cell/kotak)
	var map_rect = tilemap.get_used_rect()
	
	# 2. Mendapatkan ukuran satu cell (misalnya 16x16 atau 64x64 pixel)
	var cell_size = tilemap.tile_set.tile_size
	
	# 3. Menghitung batas dalam pixel (Cell * Ukuran Cell)
	limit_left = map_rect.position.x * cell_size.x
	limit_right = map_rect.end.x * cell_size.x
	limit_top = map_rect.position.y * cell_size.y
	limit_bottom = map_rect.end.y * cell_size.y
