extends Node

var speedrun_time: float = 0.0
var deaths: int = 0
var is_running: bool = false
var best_time: float = 9999.0

func _process(delta: float) -> void:
	if is_running:
		speedrun_time += delta


func start_run() -> void:
	speedrun_time = 0.0
	deaths = 0
	is_running = true


func stop_run() -> void:
	is_running = false


func get_formatted_time() -> String:
	@warning_ignore("integer_division")
	var minutes := int(speedrun_time) / 60
	var seconds := int(speedrun_time) % 60
	var milliseconds := int( (speedrun_time - int(speedrun_time)) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func check_new_record() -> bool:
	if speedrun_time < best_time:
		best_time = speedrun_time
		return true
	return false
