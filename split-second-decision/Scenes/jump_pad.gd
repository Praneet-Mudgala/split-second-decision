extends Area2D

const BURST_PARTICLES = preload("res://Scenes/jump_pad_particles.tscn")

@export var bounce_velocity: float = -600.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.get("is_cherry") == true:
		
		var particles = BURST_PARTICLES.instantiate()
		particles.global_position = global_position
		get_parent().add_child(particles)
		particles.burst(Color("f5f5f5ff"))
		
		body.velocity.y = bounce_velocity
