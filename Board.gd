extends Container

var tiles: Array
var Tile: PackedScene = preload ("res://Tile.tscn")
var sprite_size: int

func generate(rows: int, cols: int, bomb_count: int, new_sprite_size: int):
	sprite_size = new_sprite_size
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
			print(tile.position)
			tiles.append(tile)
			add_child(tile)

func set_bombs(bomb_count: int):
	var n: int = 0
	while n < bomb_count:
		var tile = tiles[randi() % tiles.size()]
		if !tile.is_mine:
			tile.set_bomb()
			n += 1

func loose():
	for tile in tiles:
		if tile.is_mine:
			tile.uncover()
	var Main = get_parent()
	Main.update_status(Main.GAME_STATE.LOOSE)

func check_progress():
	var is_win: bool = true
	for tile in tiles:
		if tile.is_covered && !tile.is_mine:
			is_win = false
			break
	if is_win:
		var Main = get_parent()
		Main.update_status(Main.GAME_STATE.WIN)
