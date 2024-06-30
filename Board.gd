extends GridContainer

var tiles: Array
var Tile: PackedScene = preload ("res://Tile.tscn")
var sprite_size: int

func generate(rows: int, cols: int, bomb_count: int, sprite_size: int):
	self.sprite_size = sprite_size
	columns = cols
	create_board(rows, cols)
	set_bombs(bomb_count)

func create_board(rows: int, cols: int):
	if tiles.size() > 0||tiles.size() > 0&&rows * cols != tiles.size():
		for tile in tiles:
			tile.queue_free()
		tiles = []
	for i in rows:
		for j in cols:
			var tile: Node = Tile.instantiate()
			tile.position = Vector2(i, j) * sprite_size
			tiles.append(tile)
			add_child(tile)
			print("Tile created at: ", tile.position / sprite_size)

func set_bombs(bomb_count: int):
	var n: int = 0
	while n < bomb_count:
		var tile = tiles[randi() % tiles.size()]
		if !tile.is_mine:
			tile.set_bomb()
			print("Bomb set at: ", tile.position / sprite_size)
			n += 1

func loose_game():
	for tile in tiles:
		if (tile.is_mine):
			tile.uncover()
	var Main: Container = get_parent()
	Main.update_status(Main.GAME_STATE.LOOSE)
