extends Node2D

enum GAME_STATE { MENU, IN_PROGRESS, PAUSE, WIN, LOOSE }


func _ready():
	$Menu/Status.hide()
	update_status(GAME_STATE.MENU)


func start_game():
	$Board.generate()


func update_status(state: GAME_STATE):
	$Menu.visible = state != GAME_STATE.IN_PROGRESS
	match state:
		GAME_STATE.MENU:
			$Menu/Status.text = "Press any key to start"
		GAME_STATE.IN_PROGRESS:
			start_game()
			$Menu/Status.text = "In progress"
		GAME_STATE.PAUSE:
			$Menu/Status.text = "Paused"
		GAME_STATE.WIN:
			$Menu/Status.text = "You win!"
		GAME_STATE.LOOSE:
			$Menu/Status.text = "You loose!"


func _on_start_pressed() -> void:
	update_status(GAME_STATE.IN_PROGRESS)
