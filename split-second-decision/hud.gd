extends CanvasLayer

@export var level_name: String = "Level 1"

@export_file("*.tscn") var title_screen_path: String = "res://scenes/title_screen.tscn"

@onready var pause_menu: ColorRect = $PauseMenu


func _ready() -> void:
	$FadeRect.modulate.a = 1.0
	create_tween().tween_property($FadeRect, "modulate:a", 0.0, 0.35)
	
	pause_menu.visible = false
	$PauseMenu/VBoxContainer/ResumeButton.pressed.connect(toggle_pause)
	$PauseMenu/VBoxContainer/RestartButton.pressed.connect(restart_level)
	$PauseMenu/VBoxContainer/TitleButton.pressed.connect(go_to_title)


func _process(delta: float) -> void:
	$HudLabel.text = level_name + "  |  Time: " + Global.get_formatted_time() + "  |  Deaths: " + str(Global.deaths)
	
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()
	
	if Input.is_action_just_pressed("Restart") and not get_tree().paused:
		restart_level()


func toggle_pause() -> void:
	var is_paused := not get_tree().paused
	get_tree().paused = is_paused
	pause_menu.visible = is_paused
	
	Global.is_running = not is_paused


func restart_level() -> void:
	get_tree().paused = false
	Global.is_running = true
	Global.deaths += 1
	get_tree().reload_current_scene()


func go_to_title() -> void:
	get_tree().paused = false
	Global.stop_run()
	get_tree().change_scene_to_file(title_screen_path)
