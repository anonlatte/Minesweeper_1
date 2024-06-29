extends Node2D

func _on_control_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			print("Left mouse button pressed")
		if event.is_action_pressed("right_click"):
			print("Right mouse button pressed")
			