extends Node2D

var is_covered = true
var flagged    = false
var is_mine    = false


#func _ready():

func set_bomb():
	is_mine = true
	$Bomb.show()
	

func uncover():
	if flagged == false:
		$Cover.hide()
		is_covered = false


func toggle_flag():
	if is_covered:
		if flagged:
			$Flag.hide()
			flagged = false
		else:
			$Flag.show()
			flagged = true


func _on_control_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			uncover()
		if event.is_action_pressed("right_click"):
			toggle_flag()
