class_name Tile extends CenterContainer

var state: TILE_STATE = TILE_STATE.COVERED
var is_bomb: bool = false
var _value: int = 0


func update_state(new_state: TILE_STATE):
	state = new_state
	match state:
		TILE_STATE.COVERED:
			$Cover.show()
			$Label.hide()
			$Flag.hide()
			$Bomb.hide()
		TILE_STATE.UNCOVERED:
			$Cover.hide()
		TILE_STATE.FLAGGED:
			$Cover.hide()
			$Label.hide()
			$Flag.show()
		TILE_STATE.BOMB:
			$Cover.hide()
			$Label.hide()
			$Bomb.show()
	print("Label visible: ", $Label.is_visible_in_tree(), " with value: ", _value)


func toggle_flag():
	if state == TILE_STATE.FLAGGED:
		update_state(TILE_STATE.COVERED)
	else:
		update_state(TILE_STATE.FLAGGED)


func set_label(value: int):
	_value = value
	print("Setting label: ", value)
	if value == 0:
		$Label.hide()
		return
	$Label.text = str(value)
	$Label.show()
	# classic minesweeper's colors for numbers
	var color: Color
	match value:
		1:
			color = Color(0, 0, 255, 1)
		2:
			color = Color(0, 128, 0, 1)
		3:
			color = Color(255, 0, 0, 1)
		4:
			color = Color(0, 0, 128, 1)
		5:
			color = Color(128, 0, 0, 1)
		6:
			color = Color(0, 128, 128, 1)
		7:
			color = Color(0, 0, 0, 1)
		8:
			color = Color(128, 128, 128, 1)
	$Label.set("theme_override_colors/font_color", color)


func _on_tile_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			get_parent().uncover(self)
		if event.is_action_pressed("right_click"):
			toggle_flag()


func uncover():
	if is_bomb && (state == TILE_STATE.FLAGGED || state == TILE_STATE.COVERED):
		update_state(TILE_STATE.BOMB)
	elif state == TILE_STATE.COVERED:
		update_state(TILE_STATE.UNCOVERED)


enum TILE_STATE { COVERED, UNCOVERED, FLAGGED, BOMB }
