extends Control

@export_file("*.tscn") var title_screen_path: String = "res://Scenes/title_screen.tscn"

func _ready() -> void:
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(title_screen_path)
