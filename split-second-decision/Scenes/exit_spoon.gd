extends Area2D

var time_passed: float = 0.0
@onready var start_y: float = position.y

@export_file("*.tscn") var next_level_path: String = ""

var triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time_passed += delta
	position.y = start_y + sin(time_passed * 4.0) * 5.0

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	
	if body.has_method("win_level"):
		triggered = true
		body.win_level()
		
		await get_tree().create_timer(1.0).timeout
		
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)
		else:
			get_tree().reload_current_scene()
