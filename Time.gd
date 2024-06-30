extends Label

var time_elapsed := 0.0
var is_paused := false

func _process(delta: float) -> void:
	if !is_paused:
		time_elapsed += delta
		text = str(time_elapsed).pad_decimals(2)

func start() -> void:
	time_elapsed = 0.0
	is_paused = false

func toggle_pause() -> void:
	is_paused = !is_paused
