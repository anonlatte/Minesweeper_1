extends Node2D

var row: int = 15
var col: int = 10
var bomb_count: int = 15
var Tile: PackedScene = preload("res://Tile.tscn")
var sprite_size: int = 64
var tiles: Array

func _ready():
	for i in  row:
		for j in col:
			var tile: Node = Tile.instantiate()
			tile.position = Vector2(i, j) * sprite_size
			add_child(tile)
	tiles = get_children()
	set_bombs()

func set_bombs():
	var n: int = 0
	while n < bomb_count:
		var tile = tiles[randi() % len(tiles)]
		if not tile.is_mine:
			tile.set_bomb()
			n += 1