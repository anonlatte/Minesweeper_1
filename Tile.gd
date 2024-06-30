extends Container

var is_covered: bool = true
var flagged: bool = false
var is_mine: bool = false

func set_bomb():
	is_mine = true
	$Bomb.show()
	$Label.hide()

func uncover():
	if flagged == false:
		$Cover.hide()
		is_covered = false
		var count_surrounds: int = 0
		for tile in get_surrounds():
			if tile.is_mine:
				count_surrounds += 1
		if count_surrounds > 0:
			$Label.text = str(count_surrounds)
		else:
			for tile in get_surrounds():
				if tile.is_covered:
					tile.uncover()

func get_surrounds() -> Array[Variant]:
	var surrounds: Array[Variant] = []
	var offsets: Array[Variant] = [
		(Vector2.UP + Vector2.LEFT) * 64,
		Vector2.UP * 64,
		(Vector2.UP + Vector2.RIGHT) * 64,
		Vector2.LEFT * 64,
		Vector2.RIGHT * 64,
		(Vector2.DOWN + Vector2.LEFT) * 64,
		Vector2.UP * 64,
		(Vector2.DOWN + Vector2.RIGHT) * 64
	]
	for offset in offsets:
		for title in get_parent().tiles:
			if title.position == self.position + offset:
				surrounds.append(title)
	return surrounds

func toggle_flag():
	if is_covered:
		if flagged:
			$Flag.hide()
			flagged = false
		else:
			$Flag.show()
			flagged = true

func _on_tile_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			if !is_mine:
				uncover()
			else:
				get_parent().loose_game()
		if event.is_action_pressed("right_click"):
			toggle_flag()
