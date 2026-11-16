extends Control

@export_file("*.tscn") var first_level_path: String = "res://Scenes/level_1.tscn"

func _ready() -> void:
	Global.stop_run()
	
	var record_text := "  (NEW RECORD!)" if Global.check_new_record() else ""
	$VBoxContainer/StatsLabel.text = "Final Time: " + Global.get_formatted_time() + record_text + "\nTotal Deaths: " + str(Global.deaths)
	$VBoxContainer/ReplayButton.pressed.connect(_on_replay_pressed)


func _on_replay_pressed() -> void:
	Global.start_run()
	get_tree().change_scene_to_file(first_level_path)
