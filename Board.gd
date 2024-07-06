extends Container

var _tiles: Array[Tile]
var _TileScene: PackedScene = preload("res://Tile.tscn")
var _sprite_size: int


func generate(rows: int, cols: int, bomb_count: int, new_sprite_size: int):
	_sprite_size = new_sprite_size
	create_board(rows, cols)
	_set_bombs(bomb_count)


func uncover(tile: Tile):
	# log state
	match tile.state:
		Tile.TILE_STATE.COVERED:
			print("Covered: ", tile.position / _sprite_size, " is_bomb: ", tile.is_bomb)
		Tile.TILE_STATE.UNCOVERED:
			print("Uncovered")
		Tile.TILE_STATE.FLAGGED:
			print("Flagged")
		Tile.TILE_STATE.BOMB:
			print("Bomb")

	if tile.state == Tile.TILE_STATE.FLAGGED || tile.state == Tile.TILE_STATE.UNCOVERED:
		return
	if tile.is_bomb:
		tile.update_state(Tile.TILE_STATE.BOMB)
		_loose()
	else:
		var count_surrounds: int = 0
		var surrounds = _get_surrounds()
		for surround in surrounds:
			print("Surround: ", surround.position / _sprite_size, " is_bomb: ", surround.is_bomb, " state: ", surround.state, " label: ", surround._value)
			if surround.is_bomb:
				count_surrounds += 1
			else:
				if surround.state == Tile.TILE_STATE.COVERED:
					surround.update_state(Tile.TILE_STATE.UNCOVERED)
		tile.set_label(count_surrounds)
		tile.update_state(Tile.TILE_STATE.UNCOVERED)
		# for surround in surrounds:
		_check_progress()


func _get_surrounds() -> Array[Variant]:
	var surrounds: Array[Variant] = []
	var offsets: Array[Variant] = [
		Vector2.UP * 64,
		(Vector2.UP + Vector2.RIGHT) * 64,
		Vector2.RIGHT * 64,
		(Vector2.DOWN + Vector2.RIGHT) * 64,
		Vector2.DOWN * 64,
		(Vector2.DOWN + Vector2.LEFT) * 64,
		Vector2.LEFT * 64,
		(Vector2.UP + Vector2.LEFT) * 64,
	]
	for offset in offsets:
		for tile in _tiles:
			if tile.position == position + offset:
				surrounds.append(tile)
	return surrounds


func create_board(rows: int, cols: int):
	if _tiles.size() > 0 || _tiles.size() > 0 && rows * cols != _tiles.size():
		for tile in _tiles:
			tile.queue_free()
		_tiles = []
	for i in rows:
		for j in cols:
			var tile: Node = _TileScene.instantiate()
			tile.position = Vector2(i, j) * _sprite_size
			_tiles.append(tile)
			add_child(tile)


func _set_bombs(bomb_count: int):
	var n: int = 0
	while n < bomb_count:
		var tile = _tiles[randi() % _tiles.size()]
		if !tile.is_bomb:
			print("Bomb at: ", tile.position / _sprite_size)
			tile.is_bomb = true
			n += 1


func _check_progress():
	for tile in _tiles:
		if tile.is_bomb && tile.state == Tile.TILE_STATE.COVERED:
			return
	_win()


func _win():
	var Main = get_parent()
	Main.update_status(Main.GAME_STATE.WIN)


func _loose():
	for tile in _tiles:
		if tile.is_bomb:
			tile.uncover()
	var Main = get_parent()
	Main.update_status(Main.GAME_STATE.LOOSE)
