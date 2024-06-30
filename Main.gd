extends Container

enum GAME_STATE {MENU, START, IN_PROGRESS, PAUSE, WIN, LOOSE}

var state: GAME_STATE = GAME_STATE.MENU

func _ready():
	update_status(state)

func update_status(new_state: GAME_STATE):
	state = new_state
	$Menu.visible = state != GAME_STATE.START && state != GAME_STATE.IN_PROGRESS
	$Menu/Status.visible = state == GAME_STATE.WIN || state == GAME_STATE.LOOSE
	match state:
		GAME_STATE.MENU:
			$Time.hide()
			$Board.hide()
		GAME_STATE.START:
			start_game()
		GAME_STATE.IN_PROGRESS:
			$Time.toggle_pause()
		GAME_STATE.WIN:
			$Board.set_process_input(false)
			$Time.toggle_pause()
			$Menu/Status.text = "You win!"
			$Menu/Status.show()
		GAME_STATE.LOOSE:
			$Board.set_process_input(false)
			$Time.toggle_pause()
			$Menu/Status.text = "You loose!"
			$Menu/Status.show()

func start_game():
	var rows: int = 15
	var cols: int = 10
	var bomb_count: int = 15
	var sprite_size = 64
	# update window size
	# get_viewport().size = Vector2(cols, rows) * sprite_size
	$Time.show()
	$Time.start()
	$Board.show()
	$Board.generate(rows, cols, bomb_count, sprite_size)
	$Board.set_process_input(true)

func _on_start_pressed() -> void:
	update_status(GAME_STATE.START)

func _on_exit_pressed():
	get_tree().quit()
	
func _input(event):
	if event is InputEventKey && event.keycode == KEY_ESCAPE:
		if event.pressed:
			handle_escape()

func handle_escape():
	match state:
		GAME_STATE.MENU:
			get_tree().quit()
		GAME_STATE.START:
			update_status(GAME_STATE.MENU)
		GAME_STATE.IN_PROGRESS:
			update_status(GAME_STATE.PAUSE)
		GAME_STATE.PAUSE:
			update_status(GAME_STATE.IN_PROGRESS)
		GAME_STATE.WIN:
			update_status(GAME_STATE.MENU)
		GAME_STATE.LOOSE:
			update_status(GAME_STATE.MENU)
