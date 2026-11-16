extends Control

@export_file("*.tscn") var first_level_path: String = "res://Scenes/level_1.tscn"
@export_file("*.tscn") var controls_screen_path: String = "res://Scenes/controls_screen.tscn"

func _ready() -> void:
	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/ControlsButton.pressed.connect(_on_controls_pressed)
	
	$VBoxContainer/HBoxContainer/L1.pressed.connect(func(): start_level("res://Scenes/level_1.tscn"))
	$VBoxContainer/HBoxContainer/L2.pressed.connect(func(): start_level("res://Scenes/level_2.tscn"))
	$VBoxContainer/HBoxContainer/L3.pressed.connect(func(): start_level("res://Scenes/level_3.tscn"))
	$VBoxContainer/HBoxContainer/L4.pressed.connect(func(): start_level("res://Scenes/level_4.tscn"))



func _on_play_pressed() -> void:
	Global.start_run()
	get_tree().change_scene_to_file(first_level_path)

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file(controls_screen_path)

func start_level(path: String) -> void:
	Global.start_run()
	get_tree().change_scene_to_file(path)
