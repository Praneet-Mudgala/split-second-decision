extends Control

@export_file("*.tscn") var first_level_path: String = "res://Scenes/level_1.tscn"

func _ready() -> void:
	Global.stop_run()
	var record_text := "  (NEW RECORD!)" if Global.check_new_record() else ""
	
	var rank := "🥉 BRONZE "
	if Global.speedrun_time < 90.0:
		rank = "🥇 GOLD "
	elif Global.speedrun_time < 120.0:
		rank = "🥈 SILVER "
	
	var pacifist := ""
	if Global.deaths == 0:
		pacifist = "👑 FLAWLESS VICTORY"
	else:
		pacifist = ""
	
	$VBoxContainer/StatsLabel.text = rank + "" + pacifist +  "\nFinal Time: " + Global.get_formatted_time() + record_text + "\nTotal Deaths: " + str(Global.deaths)
	$VBoxContainer/ReplayButton.pressed.connect(_on_replay_pressed)


func _on_replay_pressed() -> void:
	Global.start_run()
	get_tree().change_scene_to_file(first_level_path)
